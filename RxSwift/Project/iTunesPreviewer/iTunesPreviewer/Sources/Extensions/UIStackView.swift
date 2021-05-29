//
//  UIStackView.swift
//  iTunesPreviewer
//
//  Created by Jmy on 2021/04/28.
//

import UIKit

extension UIStackView {
  
  // MARK: - Methods
  
  func addArrangedSubviews(_ views: UIView...) {
    views.forEach { addArrangedSubview($0) }
  }
}
