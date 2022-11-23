//
//  ContentView.swift
//  PetStore
//
//  Created by Tushar Kalra on 22/11/22.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    
    var gridItems = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
    
    @EnvironmentObject var viewModel: PetViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.shopState == .open {
                VStack(alignment: .leading) {
                    Text("Pets")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    ScrollView(.vertical){
                        LazyVGrid(columns: gridItems, spacing: 20) {
                            ForEach(viewModel.pets!.pets){ pet in
                                NavigationLink(destination: PetDetailView(pet: pet)){
                                    VStack{
                                        KFImage(URL(string: pet.imageURL))
                                            .resizable()
                                            .frame(height: 150)
                                            .scaledToFit()
                                            .cornerRadius(12)
                                        
                                        Text(pet.title)
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                    }
                                    .padding()
                                    .background(.white)
                                    .cornerRadius(8)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .shadow(color: .gray, radius: 5, x: 3, y: 6)
                        }
                    }
                    
                }
                .padding(.horizontal)
                .background(Color.init(uiColor: .lightGray).opacity(0.2))
                .onAppear(){
                    viewModel.loadingState = .loading
                    viewModel.pages.removeAll()
                }
            }
            else if viewModel.shopState == .unknown{
                Text("Loading...")
            }
            else {
                VStack(alignment: .center, spacing: 20) {
                    Text("Sorry!")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("The shop is closed currently")
                }
            }
            
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(PetViewModel())
    }
}
