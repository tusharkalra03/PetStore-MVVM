//
//  Pet.swift
//  PetStore
//
//  Created by Tushar Kalra on 22/11/22.
//

import Foundation

//MARK: - Pets
struct Pets: Codable{
    
    var pets: [Pet]
}

//MARK: - Pet
struct Pet: Codable, Identifiable{
    
    var id = UUID()
    var title: String
    var imageURL: String
    var contentURL: String
    var dateAdded: String
    
    enum CodingKeys: String, CodingKey {
        
        case title
        case imageURL = "image_url"
        case contentURL = "content_url"
        case dateAdded = "date_added"
    }
}

