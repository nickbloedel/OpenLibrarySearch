//
//  APIError.swift
//  MyApp
//
//  Created by Nicholas Bloedel on 10/18/26.
//

import Foundation
enum APIError: Error, LocalizedError {
    case decoding(error: any Error)
    case invalidURL
    case httpError(code: Int, message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .decoding(let error):
            "Failed to decode. Error: \(error)"
        case .httpError(let code, let message):
            "HTTP Status Code: \(code): \(message)"
        }
    }
}
