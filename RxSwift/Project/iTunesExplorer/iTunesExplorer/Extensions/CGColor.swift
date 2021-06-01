//
//  CGColor.swift
//  iTunesExplorer
//
//  Created by Jmy on 2021/04/21.
//

import UIKit

extension CGColor {
  
  // MARK: - Methods
  
  class func white(_ white: CGFloat, _ alpha: CGFloat = 1.0) -> CGColor {
    return UIColor.white(white, alpha).cgColor
  }
  
  class func rgb(r: CGFloat, g: CGFloat, b: CGFloat, _ alpha: CGFloat = 1.0) -> CGColor {
    return UIColor.rgb(r: r, g: g, b: b).cgColor
  }
}
