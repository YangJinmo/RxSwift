//
//  UIView.swift
//  iTunesPreviewer
//
//  Created by YangJinMo on 2021/04/28.
//

import UIKit

extension UIView {
  
  func addSubviews(_ views: UIView...) {
    views.forEach { addSubview($0); $0.translatesAutoresizingMaskIntoConstraints = false }
  }
}
