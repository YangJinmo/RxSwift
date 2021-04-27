//
//  NSObject.swift
//  iTunesExplorer
//
//  Created by YangJinMo on 2021/04/23.
//

import UIKit

extension NSObject {
  
  // Creates a string representing the given value.
  static var description: String {
    return String(describing: self)
  }
  
  // Returns the dynamic type of a value.
  public var dynamicType: String {
    return type(of: self).description
  }
}
