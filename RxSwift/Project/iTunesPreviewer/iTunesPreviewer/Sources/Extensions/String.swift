//
//  String.swift
//  iTunesPreviewer
//
//  Created by Jmy on 2021/04/28.
//

import Foundation

extension String {
  
  // MARK: - Variables
  
  var url: URL? {
    return URL(string: self)
  }
  
  var urlComponents: URLComponents? {
    return URLComponents(string: self)
  }
  
  var encode: String? {
    return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
  }
  
  // MARK: - Methods
  
  func log(function: String = #function, _ comment: String = "") {
    print("func \(function) \(comment)\(self)")
  }
}
