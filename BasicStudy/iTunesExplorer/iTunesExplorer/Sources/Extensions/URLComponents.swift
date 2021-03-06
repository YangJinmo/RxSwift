//
//  URLComponents.swift
//  iTunesExplorer
//
//  Created by Jmy on 2021/05/31.
//

import Foundation

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
