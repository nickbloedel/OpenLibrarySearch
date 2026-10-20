//
//  BookService.swift
//  OpenLibrarySearch
//
//  Created by Nicholas Bloedel on 10/19/26.
//

import Foundation

struct BookService {
    private var client: OpenLibraryClient
    
    init(client: OpenLibraryClient = OpenLibraryClient()) {
        self.client = client
    }
    
    func fetchBooksByTitle(_ title: String) async throws -> [Book] {
        let response: BookResponse = try await client.request(request: OpenLibraryRequest.searchTitle(title: title))
        return response.books
    }
    
    func fetchBooksByAuthor(_ author: String) async throws -> [Book] {
        let response: BookResponse = try await client.request(request: OpenLibraryRequest.searchAuthor(author: author))
        return response.books
    }
    
    func fetchBooksBySubject(_ subject: String) async throws -> [Book] {
        let response: BookResponse = try await client.request(request: OpenLibraryRequest.searchSubject(subject: subject))
        return response.books
    }
    
}
