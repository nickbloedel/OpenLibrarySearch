//
//  Book.swift
//  MyApp
//
//  Created by Nicholas Bloedel on 10/18/26.
//

import Foundation

struct Book: Identifiable, Hashable, Decodable {
    
    static var preview: Book = Book(id: "/works/OL14926019W", title: "The Lord of the Rings", author: "J. R. R. Tolkien", year: 1954, isbn: "1231231123as", coverArtID: 258027, subject: "Fantasy")
    
    
    let id: String
    let title: String
    let author: String?
    let year: Int?
    let isbn: String?
    let coverArtID: Int?
    let subject: String?
    
    
    var coverURL: URL? {
        guard let coverArtID else { return nil }
        // hardcoding for now
        return URL(string: "https://covers.openlibrary.org/b/id/\(coverArtID)-M.jpg")
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id = "key"
        case title
        case author = "author_name"
        case year = "first_publish_year"
        case isbn = "isbn"
        case coverArtID = "cover_i"
        case subject
    }
    
    init(id: String, title: String, author: String?, year: Int?, isbn: String?, coverArtID: Int?, subject: String?) {
        self.id = id
        self.title = title
        self.author = author
        self.year = year
        self.isbn = isbn
        self.coverArtID = coverArtID
        self.subject = subject
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        let authors = try container.decodeIfPresent([String].self, forKey: .author)
        author = authors?.joined(separator: ", ")
        self.year = try container.decodeIfPresent(Int.self, forKey: .year)
        let isbns = try container.decodeIfPresent([String].self, forKey: .isbn)
        isbn = isbns?.first // Assuming first one is fine
        self.coverArtID = try container.decodeIfPresent(Int.self, forKey: .coverArtID)
        let subjects = try container.decodeIfPresent([String].self, forKey: .subject)
        subject = subjects?.first
    }
    
}
