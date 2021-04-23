//
//  UIImageView.swift
//  iTunesExplorer
//
//  Created by YangJinMo on 2021/04/23.
//

import UIKit

extension UIImageView {
  
  func setImage(urlString: String?) {
    guard
      let urlString: String = urlString, // check nil
      let url: URL = urlString.toURL // check "" and convert URL
    else {
      self.image = nil
      return
    }
    setImage(url: url)
  }
  
  func setImage(url: URL) {
    
    DispatchQueue.global().async { [weak self] in
      
      let data: Data? = try? Data(contentsOf: url)
      
      DispatchQueue.main.async { [weak self] in
        guard let data = data else {
          self?.image = nil
          return
        }
        self?.image = UIImage(data: data)
      }
    }
  }
}
