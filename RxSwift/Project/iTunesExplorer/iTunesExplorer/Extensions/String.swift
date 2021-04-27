//
//  String.swift
//  iTunesExplorer
//
//  Created by YangJinMo on 2021/04/22.
//

import UIKit

extension String {
  
  func log(function: String = #function, _ comment: String = "") {
    print("func \(function) \(comment)\(self)")
  }
  
  var toURL: URL? {
    return URL(string: self)
  }
}
