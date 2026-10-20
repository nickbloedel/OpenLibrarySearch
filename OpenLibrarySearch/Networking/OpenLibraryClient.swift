//
//  OpenLibraryClient.swift
//  MyApp
//
//  Created by Nicholas Bloedel on 10/18/26.
//

import Foundation

struct OpenLibraryClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }
    // Should make into own service, convert to [Book] within
    func fetchBooksByTitle(_ title: String) async throws -> BookResponse {
        try await request(request: OpenLibraryRequest.searchTitle(title: title))
    }
    
    func fetchBooksByAuthor(_ author: String) async throws -> BookResponse {
        try await request(request: OpenLibraryRequest.searchAuthor(author: author))
    }
    
    func fetchBooksBySubject(_ subject: String) async throws -> BookResponse {
        try await request(request: OpenLibraryRequest.searchSubject(subject: subject))
    }
    
    private func request<T: Decodable>(request: OpenLibraryRequest) async throws -> T {
        let urlRequest = try buildRequest(request: request)
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidURL
        }
        
        // handle rate limit
        switch httpResponse.statusCode {
        case 200:
            break
        case 429:
            throw APIError.rateLimit
        default:
            throw APIError.httpError(code: httpResponse.statusCode, message: String(data: data, encoding: .utf8) ?? "")
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error: error)
        }
    }
    
    private func buildRequest(request: OpenLibraryRequest) throws -> URLRequest {
        guard let url = URL(string: request.baseURL) else {
            throw APIError.invalidURL
        }
        guard var urlComponents = URLComponents(url: url.appending(path: request.path), resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        
        urlComponents.queryItems = request.queryItems()
        
        guard let builtURL = urlComponents.url else {
            throw APIError.invalidURL
        }
        return URLRequest(url: builtURL)
    }
}
