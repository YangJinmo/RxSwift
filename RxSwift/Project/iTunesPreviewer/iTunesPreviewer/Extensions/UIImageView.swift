//
//  UIImageView.swift
//  iTunesPreviewer
//
//  Created by YangJinMo on 2021/04/28.
//

import UIKit

extension UIImageView {
  
  func setImage(urlString: String?, placeholder: UIImage? = nil) {
    let url: URL? = urlString.flatMap { $0.toURL }
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
  
  // MARK: - Synchronously
  
  func setImageSynchronously(resource: String?, type: String? = "jpg") {
    guard
      let filePath: String = Bundle.main.path(forResource: resource, ofType: type),
      let image: UIImage = UIImage(contentsOfFile: filePath)
    else {
      return
    }
    self.image = image
  }
  
  // MARK: - Download
  
  func setImageDownload(urlString: String?, placeholder: UIImage? = nil) {
    let url: URL? = urlString.flatMap { $0.toURL }
    setImageDownload(url: url, placeholder: placeholder)
  }
  
  func setImageDownload(url: URL?, placeholder: UIImage? = nil) {
    
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
      }
    }
  }
  
  private func getData(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
  }
  
  // MARK: - Retrieve Memory Cache
  
  func setImageRetrieveInMemoryCache(urlString: String?) {
    
    guard let urlString: String = urlString else { return }
    
    let cacheKey: NSString = NSString(string: urlString) // 캐시에 사용될 Key 값
    
    if let cachedImage: UIImage = ImageCacheManager.shared.object(forKey: cacheKey) { // 해당 Key에 캐시이미지가 저장되어 있으면 이미지를 사용
      self.image = cachedImage
    } else if let url: URL = urlString.toURL {
      DispatchQueue.global(qos: .background).async {
        self.getData(with: url) { [weak self] data, response, error in
          if let error = error {
            error.localizedDescription.log()
            DispatchQueue.main.async {
              self?.image = nil
            }
            return
          }
          
          guard
            let response: HTTPURLResponse = response as? HTTPURLResponse, response.statusCode == 200,
            let mimeType: String = response.mimeType, mimeType.hasPrefix("image"),
            let data: Data = data
          else {
            "error: response, data".log()
            DispatchQueue.main.async {
              self?.image = nil
            }
            return
          }
          
          let filename: String = response.suggestedFilename ?? url.lastPathComponent
          filename.log()
          
          DispatchQueue.main.async {
            guard let image = UIImage(data: data) else {
              self?.image = nil
              return
            }
            ImageCacheManager.shared.setObject(image, forKey: cacheKey) // 다운로드된 이미지를 캐시에 저장
            self?.image = image
          }
        }
      }
    }
  }
  
  // MARK: - Retrieve Disk Cache
  
  func setImageRetrieveInDiskCache(urlString: String?) {
    
    guard let urlString: String = urlString else { return }
    
    // FileManager 인스턴스 생성. default는 FileManager 싱글톤 인스턴스를 만들어줌
    // FileManager는 URL 혹은 String 데이터 타입을 통해 파일에 접근할 수 있도록 합니다
    // Apple에서는 URL을 통한 파일 접근을 권장함
    let fileManager: FileManager = FileManager.default
    
    // cache 디렉토리의 경로 저장
    // urls(for:in:): 메소드를 통해 특정 경로에 접근
    let urls: [URL] = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
    
    // 해당 디렉토리 이름 지정.
    // /Library/Caches/DiskCache <- 경로를 저장
    let dataPathUrl: URL = urls.first!.appendingPathComponent("DiskCache") //(name + ".cache")
    let dataPath: String = dataPathUrl.path
    
    if !fileManager.fileExists(atPath: dataPath) {
      do {
        "경로를 생성합니다".log()
        // 디렉토리 생성
        try fileManager.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
      } catch {
        "Error creating directory: \(error.localizedDescription)".log()
      }
    }
    
    let strPathUrl: URL = dataPathUrl.appendingPathComponent("project_lunch.png")
    let strPath: String = strPathUrl.path
    
    if fileManager.fileExists(atPath: strPath) {
      "디스크 캐시에 이미지가 존재합니다".log()
      do {
        let data: Data = try Data(contentsOf: strPathUrl)
        let image: UIImage? = UIImage(data: data)
        DispatchQueue.main.async { [weak self] in
          self?.image = image
        }
      } catch {
        "Error : \(error.localizedDescription)".log()
      }
    } else if let url: URL = urlString.toURL {
      
      // "Image Download" 버튼을 누르면 URLSession을 이용하여 data를 받아오고 각 ImageView에 넣는 작업
      getData(with: url) { [weak self] data, response, error in
        
        if let error = error {
          error.localizedDescription.log()
        }
        
        guard
          let response: HTTPURLResponse = response as? HTTPURLResponse, response.statusCode == 200,
          let mimeType: String = response.mimeType, mimeType.hasPrefix("image"),
          let data: Data = data,
          let image: UIImage = UIImage(data: data)
        else {
          "error: response, data".log()
          return
        }
        
        let filename: String = response.suggestedFilename ?? url.lastPathComponent
        filename.log()
        
        /**
         디스크 캐시는 iOS의 파일 시스템을 사용하여 객체에서 변환 된 데이터를 저장.
         일반적으로 앱의 캐시 디렉토리에 자체 디렉토리를 만듭니다.
         모든 객체에 대해 파일이 생성됩니다.
         */
        
        DispatchQueue.main.async { [weak self] in
          self?.image = image
        }
        
        let pngData: Data? = image.pngData()
        
        // store it in the document directory
        fileManager.createFile(
          atPath: strPath,
          contents: pngData,
          attributes: nil
        )
      }
    }
  }
}

final class ImageCacheManager {
  
  // MARK: - Static Constants
  
  static let shared = NSCache<NSString, UIImage>()
  
  // MARK: - Initialization
  
  private init() {}
}

class AnyDiskCache {
  
  // MARK: - Static Methods
  
  static func invalidate(name: String) throws {
    let fileManager: FileManager = FileManager.default
    let urls: [URL] = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
    let url: URL = urls[0].appendingPathComponent(name + ".cache")
    try fileManager.removeItem(at: url)
  }
}

final class DiskCache<T: Codable>: AnyDiskCache {
  
  // MARK: - Methods
  
  func save(object: T, name: String) throws {
    // Preventing caching empty arrays
    if let collection = object as? Array<T>, collection.isEmpty {
      return
    }
    
    let urls: [URL] = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    let url: URL = urls[0].appendingPathComponent(name + ".cache")
    
    guard let data = try? JSONEncoder().encode(object) else { return }
    try data.write(to: url)
  }
  
  func retrieve(name: String) throws -> T?  {
    let urls: [URL] = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    let url: URL = urls[0].appendingPathComponent(name + ".cache")
    guard let data = try? Data(contentsOf: url) else { return nil }
    return try JSONDecoder().decode(T.self, from: data)
  }
}
