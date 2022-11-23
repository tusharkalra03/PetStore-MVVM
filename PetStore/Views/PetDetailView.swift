//
//  PetDetailView.swift
//  PetStore
//
//  Created by Tushar Kalra on 22/11/22.
//

import SwiftUI
import Kingfisher

struct PetDetailView: View {
    
    var pet: Pet!
    @EnvironmentObject var viewModel: PetViewModel
    
    var body: some View {
        VStack{
            switch viewModel.loadingState{
            case .loading:
                Text("Loading...")
            case .loaded:
                VStack(alignment: .leading, spacing: 20) {
                    Text(viewModel.pages.first!.title)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        
                    
                    KFImage(URL(string: pet.imageURL))
                        .resizable()
                        .frame(height: 250)
                        .scaledToFit()
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .shadow(color: .gray, radius: 8, x: 3, y: 5)
                    
                    ScrollView(.vertical){
                        Text(viewModel.pages.first!.extract)
                            .fontWeight(.light)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(2)
                            .padding()
                            .padding(.vertical)
                    }
                    .background(.white)
                    .cornerRadius(32)
                    .ignoresSafeArea(edges: .bottom)
                }
                .background(Color.init(uiColor: .lightGray).opacity(0.2))
                
            case .failed:
                Text("Error Occured :/")
            }
        }
        .task {
            await viewModel.fetchDetail(of: pet)
        }
       
        
        
    }
}
//struct PetDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PetDetailView(pet: )
//            .environmentObject(PetViewModel())
//    }
//}
