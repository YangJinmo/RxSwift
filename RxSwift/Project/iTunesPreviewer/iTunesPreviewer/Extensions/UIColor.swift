//
//  UIColor.swift
//  iTunesPreviewer
//
//  Created by YangJinMo on 2021/04/28.
//

import UIKit

extension UIColor {
  
  // MARK: - Variables
  
  static var tintColor: UIColor { return .systemRed }
  
  // MARK: - Methods
  
  class func white(_ white: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(white: white / 255.0, alpha: alpha)
  }
  
  class func rgb(r: CGFloat, g: CGFloat, b: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
  }
}
