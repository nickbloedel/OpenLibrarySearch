//
//  OpenLibraryRequest.swift
//  MyApp
//
//  Created by Nicholas Bloedel on 10/18/26.
//

import Foundation

enum OpenLibraryRequest: Request {
    
    case searchTitle(title: String)
    case searchAuthor(author: String)
    case searchSubject(subject: String)
    
    var baseURL: String {
        "https://openlibrary.org"
    }
    
    var path: String {
        "/search.json"
    }
    
    func queryItems(limit: Int = 50, offset: Int = 0) -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        switch self {
        case .searchTitle(let title):
            items.append(URLQueryItem(name: "title", value: title))
        case .searchAuthor(let author):
            items.append(URLQueryItem(name: "author", value: author))
        case .searchSubject(let subject):
            items.append(URLQueryItem(name: "subject", value: subject))
        }
        // hard coding for now, can add pagination/infinite scroll later
        items.append(URLQueryItem(name: "offset", value: String(offset)))
        items.append(URLQueryItem(name: "limit", value: String(limit)))
        
        let fields: String = Book.CodingKeys.allCases.map { $0.stringValue }.joined(separator: ",")
        
        items.append(URLQueryItem(name: "fields", value: fields))
        
        return items
    }
}
