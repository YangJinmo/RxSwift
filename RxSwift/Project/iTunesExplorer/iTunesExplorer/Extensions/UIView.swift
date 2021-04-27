//
//  UIView.swift
//  iTunesExplorer
//
//  Created by YangJinMo on 2021/04/21.
//

import UIKit

extension UIView {
  
  func addSubviews(_ views: UIView...) {
    views.forEach { addSubview($0); $0.translatesAutoresizingMaskIntoConstraints = false }
  }
}
