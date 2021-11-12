//
//  BaseCollectionViewCell.swift
//  iTunesExplorer
//
//  Created by Jmy on 2021/04/21.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    // MARK: - Initialization

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setupViews() {
    }
}
