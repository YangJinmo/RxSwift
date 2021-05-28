//
//  BaseCollectionViewCell.swift
//  iTunesPreviewer
//
//  Created by YangJinMo on 2021/04/28.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal Methods
  
  func setupViews() {
    
  }
}
