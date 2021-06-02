//
//  RestaurantsListViewModel.swift
//  MVVMRxSwiftStudy
//
//  Created by Jmy on 2021/04/11.
//

import Foundation
import RxSwift
import RxRelay

final class RestaurantsListViewModel: BaseViewModel {
  
  private let restaurantService: RestaurantServiceProtocol
  
  // 양방향 바인딩
  let title: BehaviorRelay<String> = .init(value: "Restaurants")
  let restaurantList: BehaviorRelay<[Restaurant]> = .init(value: [])
  
  // 단방향 바인딩
  //private let _title: BehaviorRelay<String> = .init(value: "Restaurants")
  //let title: Observable<String> = _title
  
  //private let _restaurantList: BehaviorRelay<[Restaurant]> = .init(value: [])
  //let restaurantList: Observable<[Restaurant]> = _restaurantList
  
  init(restaurantService: RestaurantServiceProtocol = RestaurantService()) {
    self.restaurantService = restaurantService
  }
  
  override func start() {
    restaurantService.fetchRestaurants()
      .bind(to: restaurantList)
      //.bind(to: _restaurantList)
      .disposed(by: disposeBag)
  }
}
