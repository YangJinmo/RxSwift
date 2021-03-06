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
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?

    // MARK: - Methods

    func getSearchResults(searchTerm: String) -> Observable<[Music]> {
        return Observable.create { observer -> Disposable in

            self.dataTask?.cancel()
            
            guard var urlComponents: URLComponents = "https://itunes.apple.com/search".urlComponents else {
                observer.onError(NSError(domain: "error: urlComponents", code: -1, userInfo: nil))
                return Disposables.create()
            }

            let query: String = searchTerm.replacingOccurrences(of: " ", with: "+")
            urlComponents.query = "media=music&entity=song&term=\(query)"

            guard let url: URL = urlComponents.url else {
                observer.onError(NSError(domain: "error: \(urlComponents.string ?? "")", code: -1, userInfo: nil))
                return Disposables.create()
            }

            self.dataTask = self.defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }

                if let error: Error = error {
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
