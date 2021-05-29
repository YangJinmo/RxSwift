//
//  QueryService.swift
//  iTunesPreviewer
//
//  Created by Jmy on 2021/04/28.
//

import RxSwift

protocol QueryServiceProtocol {
  func getSearchResults(searchTerm: String) -> Observable<[Music]>
}

/// Runs query data task, and stores results in array of Musics
class QueryService: QueryServiceProtocol {
  
  // MARK: - Constants
  
  let defaultSession = URLSession(configuration: .default)
  
  // MARK: - Variables And Properties
  
  var dataTask: URLSessionDataTask?
  
  // MARK: - Internal Methods
  
  func getSearchResults(searchTerm: String) -> Observable<[Music]> {
    
    return Observable.create { observer -> Disposable in
      
      self.dataTask?.cancel()
      
      guard var urlComponents = URLComponents(string: "https://itunes.apple.com/search") else {
        observer.onError(NSError(domain: "error: urlComponents", code: -1, userInfo: nil))
        return Disposables.create()
      }
      
      let query = searchTerm.replacingOccurrences(of: " ", with: "+")
      urlComponents.query = "media=music&entity=song&term=\(query)"
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
      
      guard let url = urlComponents.url else {
        observer.onError(NSError(domain: "error: \(urlComponents.string ?? "")", code: -1, userInfo: nil))
        return Disposables.create()
      }
      
      self.dataTask = self.defaultSession.dataTask(with: url) { [weak self] data, response, error in
        defer {
          self?.dataTask = nil
        }
        
        if let error = error {
          observer.onError(NSError(domain: "error: \(error.localizedDescription)", code: -1, userInfo: nil))
        } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
          do {
            let musics = try JSONDecoder().decode(Musics.self, from: data)
            observer.onNext(musics.results)
          } catch {
            observer.onError(
              NSError(
                domain: "JSON Decode error: \(error.localizedDescription)",
                code: -1,
                userInfo: nil
              )
            )
          }
        } else {
          searchTerm.log()
        }
      }
      self.dataTask?.resume()
      
      return Disposables.create {
        self.dataTask?.cancel()
      }
    }
  }
}
