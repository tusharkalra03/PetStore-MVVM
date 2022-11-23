//
//  WikiResult.swift
//  PetStore
//
//  Created by Tushar Kalra on 22/11/22.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Page]
}

struct Page: Codable {
    let pageid: Int
    let title: String
    let extract: String
}


