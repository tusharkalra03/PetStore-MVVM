//
//  AppStates.swift
//  PetStore
//
//  Created by Tushar Kalra on 23/11/22.
//

import Foundation

//MARK: - Data Loading (for detail view)
enum DataLoadingState {
    case loading,loaded,failed
}

//MARK: - Shop State
enum ShopState {
    case open,closed,unknown
}
