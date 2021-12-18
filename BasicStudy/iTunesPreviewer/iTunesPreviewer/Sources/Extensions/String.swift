//
//  String.swift
//  iTunesPreviewer
//
//  Created by Jmy on 2021/04/28.
//

import Foundation

extension String {
    var url: URL? {
        return URL(string: self)
    }

    var urlComponents: URLComponents? {
        return URLComponents(string: self)
    }

    // MARK: - Methods

    func log(function: String = #function, _ comment: String = "") {
        print("func \(function) \(comment)\(self)")
    }
}
