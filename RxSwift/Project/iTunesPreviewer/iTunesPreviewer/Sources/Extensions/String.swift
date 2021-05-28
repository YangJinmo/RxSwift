//
//  String.swift
//  iTunesPreviewer
//
//  Created by YangJinMo on 2021/04/28.
//

import Foundation

extension String {
  
  // MARK: - Variables
  
  var toURL: URL? {
    return URL(string: self)
  }
  
  // MARK: - Methods
  
  func log(function: String = #function, _ comment: String = "") {
    print("func \(function) \(comment)\(self)")
  }
}
