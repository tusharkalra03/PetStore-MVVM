//
//  PetViewModel.swift
//  PetStore
//
//  Created by Tushar Kalra on 22/11/22.
//

import Foundation
import SwiftUI

class PetViewModel: ObservableObject{
    
    @Published var pets: Pets?
    @Published var pages = [Page]()
    @Published var loadingState: DataLoadingState = .loading
    @Published var shopState: ShopState = .unknown
    
    private var settings = [String:AnyObject]()
    
    init(){
        getConfig()
    }
    
    //MARK: - Get Config
    private func getConfig(){
        
        guard let fileURL = Bundle.main.url(forResource: "config", withExtension: "json") else {
            return
        }
        
        guard let data =  try? Data(contentsOf: fileURL) else {
            return
        }
        
        do{
            if let config = try? JSONSerialization.jsonObject(with: data) as? [String : AnyObject]{
                if let settings = config["settings"] as? [String : AnyObject]{
                    self.settings = settings
                }
            }
        }
        
        checkShopStatus()

    }
    
    //MARK: - Check Shop Status
    /// Sets the shop state to open or closed
    private func checkShopStatus(){
        let today = Date()
        let day = Calendar.current.component(.weekday, from: today)
        let hour =  Calendar.current.component(.hour, from: today)
        let minutes =  Calendar.current.component(.minute, from: today)
        
        var dayInWords = ""
        switch day{
        case 1:
            dayInWords = "Sunday"
        case 2:
            dayInWords = "Monday"
        case 3:
            dayInWords = "Tuesday"
        case 4:
            dayInWords = "Wednesday"
        case 5:
            dayInWords = "Thursday"
        case 6:
            dayInWords = "Friday"
        case 7:
            dayInWords = "Saturday"
        default:
            break
        }
        
        let workDays = settings["workingDays"] as! [String]
        let workHours = settings["workingHours"] as! [Int]
        
        if !workDays.contains(dayInWords) || (hour*100 + minutes < workHours[0]) || (hour*100 + minutes > workHours[1]){
            DispatchQueue.main.async {
                self.shopState = .closed
            }
            return
        }
        
        DispatchQueue.main.async {
            self.shopState = .open
            self.fetchData()
        }
        
    }
    
    //MARK: - Fetch Pets
    /// If shop is open, data about pets is fetched
    private func fetchData(){
        
        guard let fileURL = Bundle.main.url(forResource: "pets_list", withExtension: "json") else {
            return
        }
        
        guard let data =  try? Data(contentsOf: fileURL) else {
            return
        }
        
        let decoder = JSONDecoder()
        
        guard let pets = try? decoder.decode(Pets.self, from: data) else {
            return
        }
        self.pets = pets
    }
    
    //MARK: - Fetch Detail
    /// Fetches detail of selected pet and displays in PetDetailView
    func fetchDetail(of pet: Pet) async {
        
        let words = pet.title.components(separatedBy: " ")
        var title = words.first!
        
        if words.count > 1 {
            for i in 1..<words.count {
                title += "_" + words[i].lowercased()
            }
        }
        
        let urlString = "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&meta=&continue=&titles=\(title)&formatversion=2&exintro=1&explaintext=1"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.loadingState = .failed
            }
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let items = try JSONDecoder().decode(Result.self, from: data)
            
            DispatchQueue.main.async {
                self.pages = items.query.pages
                self.loadingState = .loaded
            }
        }
        catch {
            DispatchQueue.main.async {
                self.loadingState = .failed
            }
            
        }
        
    }
}
