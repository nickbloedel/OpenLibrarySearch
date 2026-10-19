//
//  BookResponse.swift
//  MyApp
//
//  Created by Nicholas Bloedel on 10/19/26.
//

import Foundation

struct BookResponse: Decodable {
    let books: [Book]
    
    enum CodingKeys: String, CodingKey {
        case books = "docs"
    }
}
