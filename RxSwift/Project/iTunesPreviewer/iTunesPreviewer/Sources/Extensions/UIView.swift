//
//  UIView.swift
//  iTunesPreviewer
//
//  Created by Jmy on 2021/04/28.
//

import UIKit

extension UIView {
    // MARK: - Methods

    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
