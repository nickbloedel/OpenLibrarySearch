//
//  Request.swift
//  MyApp
//
//  Created by Nicholas Bloedel on 10/18/26.
//

import Foundation

protocol Request {
    var baseURL: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    // headers, method, ...
}
