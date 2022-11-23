//
//  PetStoreApp.swift
//  PetStore
//
//  Created by Tushar Kalra on 22/11/22.
//

import SwiftUI

@main
struct PetStoreApp: App {
    @StateObject var viewModel = PetViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(viewModel)
        }
    }
}
