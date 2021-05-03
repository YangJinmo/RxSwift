//
//  UIImageView.swift
//  iTunesPreviewer
//
//  Created by YangJinMo on 2021/04/28.
//

import UIKit

extension UIImageView {
  
  func setImage(urlString: String?, placeholder: UIImage? = nil) {
    guard let urlString: String = urlString else { return }
    setImage(url: urlString.toURL, placeholder: placeholder)
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
        //self?.setNeedsLayout()
      }
    }
  }
  
  func setImageSynchronously(resource: String?, type: String? = "jpg") {
    guard
      let filePath: String = Bundle.main.path(forResource: resource, ofType: type),
      let image: UIImage = UIImage(contentsOfFile: filePath)
    else {
      return
    }
    self.image = image
  }
  
  func downloadImage(urlString: String?, placeholder: UIImage? = nil) {
    guard let urlString: String = urlString else { return }
    downloadImage(url: urlString.toURL, placeholder: placeholder)
  }
  
  func downloadImage(url: URL?, placeholder: UIImage? = nil) {
    
    if image == nil {
      image = placeholder
    }
    
    guard let url: URL = url else { return }
    
    getData(with: url) { [weak self] data, response, error -> Void in
      
      if let error = error {
        error.localizedDescription.log()
      }
      
      guard
        let response: HTTPURLResponse = response as? HTTPURLResponse, response.statusCode == 200,
        let mimeType: String = response.mimeType, mimeType.hasPrefix("image"),
        let data: Data = data
      else {
        "error: response, data".log()
        return
      }
      
      let filename: String = response.suggestedFilename ?? url.lastPathComponent
      filename.log()
      
      DispatchQueue.main.async { [weak self] in
        self?.image = UIImage(data: data)
        //self?.setNeedsLayout()
      }
    }
  }
  
  private func getData(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
  }
}
