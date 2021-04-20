//
//  RestaurantsListModel.swift
//  MVVMRxSwift
//
//  Created by YangJinMo on 2021/04/11.
//

import Foundation
import RxSwift

final class RestaurantsListViewModel {
  let title = "Restaurants"
  
  private let restaurantService: RestaurantServiceProtocol
  
  init(restaurantService: RestaurantServiceProtocol = RestaurantService()) {
    self.restaurantService = restaurantService
  }
  
  func fetchRestaurantViewModels() -> Observable<[Restaurant]> {
    restaurantService.fetchRestaurants()
  }
}
