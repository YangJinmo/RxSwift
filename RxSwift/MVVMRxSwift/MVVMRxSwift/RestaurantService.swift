//
//  RestaurantService.swift
//  MVVMRxSwift
//
//  Created by YangJinMo on 2021/04/09.
//

import Foundation
import RxSwift

class RestaurantService {
  
  func fetchRestaurants() -> Observable<[Restaurant]> {
    return Observable.create { observer -> Disposable in
      /*
      let task = URLSession.shared.dataTask(with: URL(fileURLWithPath: "path")) { data, _, _ in
        
        guard let data = data else {
          observer.onError(NSError(domain: "", code: -1, userInfo: nil))
          return
        }
        
        do {
          let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
          observer.onNext(restaurants)
        } catch {
          observer.onError(error)
        }
      }
      task.resume()
      
      return Disposables.create {
        task.cancel()
      }
       */
      
      guard let path = Bundle.main.path(forResource: "restaurants", ofType: "json") else {
        observer.onError(NSError(domain: "", code: -1, userInfo: nil))
        return Disposables.create()
      }
      
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
        observer.onNext(restaurants)
      } catch {
        observer.onError(error)
      }
      
      return Disposables.create()
    }
  }
  
}
