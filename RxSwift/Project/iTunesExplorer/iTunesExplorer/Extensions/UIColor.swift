//
//  UIColor.swift
//  iTunesExplorer
//
//  Created by YangJinMo on 2021/04/21.
//

import UIKit

extension UIColor {
  
  class func white(_ white: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(white: white / 255.0, alpha: alpha)
  }
  
  class func rgb(r: CGFloat, g: CGFloat, b: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
  }
  
  struct Theme {
    static var tintColor: UIColor { return .systemRed }
  }
}
