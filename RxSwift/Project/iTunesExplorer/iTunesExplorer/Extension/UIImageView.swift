//
//  UIImageView.swift
//  iTunesExplorer
//
//  Created by YangJinMo on 2021/04/23.
//

import UIKit

extension UIImageView {
  
  func setImage(urlString: String?, placeholder: UIImage? = nil) {
    guard
      let urlString: String = urlString,
      let url: URL = urlString.toURL
    else {
      return
    }
    setImage(url: url, placeholder: placeholder)
  }
  
  func setImage(url: URL?, placeholder: UIImage? = nil) {
    
    if self.image == nil {
      self.image = placeholder
    }
    
    guard let url: URL = url else { return }
    
    // 싱글 쓰레드로 동작하기 때문에 이미지를 다운로드 받기까지 잠깐의 멈춤이 발생할 수 있다.
    // DispatchQueue를 사용하면 멀티 쓰레드로 동작하여 멈춤이 생기지 않는다.
    DispatchQueue.global().async { [weak self] in
      
      let data: Data? = try? Data(contentsOf: url)
      
      DispatchQueue.main.async { [weak self] in
        guard let data = data else {
          self?.image = placeholder
          return
        }
        self?.image = UIImage(data: data)
      }
    }
  }
  
  func setImageSynchronously(resource: String, type: String = "jpg") {
    guard
      let filePath: String = Bundle.main.path(forResource: resource, ofType: type),
      let image: UIImage = UIImage(contentsOfFile: filePath)
    else {
      return
    }
    self.image = image
  }
  
  private func getData(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
  }
  
  func downloadImage(urlString: String, placeholder: UIImage? = nil) {
    guard let url: URL = urlString.toURL else {
      "fail: convert URL".log()
      return
    }
    downloadImage(url: url, placeholder: placeholder)
  }
  
  func downloadImage(url: URL, placeholder: UIImage? = nil) {
    
    if image == nil {
      image = placeholder
    }
    
    getData(with: url) { [weak self] data, response, error -> Void in
      
      if let error = error {
        error.localizedDescription.log()
      }
      
      guard
        let response = response as? HTTPURLResponse, response.statusCode == 200,
        let mimeType = response.mimeType, mimeType.hasPrefix("image"),
        let data = data
      else {
        "error: response, data".log()
        return
      }
      
      let filename = response.suggestedFilename ?? url.lastPathComponent
      filename.log()
      
      DispatchQueue.main.async { [weak self] in
        self?.image = UIImage(data: data)
        //self?.setNeedsLayout()
      }
    }
  }
}
