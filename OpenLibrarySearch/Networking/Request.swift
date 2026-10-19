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
    func queryItems(limit: Int, offset: Int) -> [URLQueryItem]
    // headers, method, ...
}
