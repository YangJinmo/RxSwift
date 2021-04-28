//
//  MusicControlButton.swift
//  iTunesPreviewer
//
//  Created by YangJinMo on 2021/04/28.
//

import UIKit

class MusicControlButton: BaseButton {
  
  override func setupViews() {
    super.setupViews()
    
    tintColor = .label
    setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
    setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .selected)
  }
}
