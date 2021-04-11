//
//  RestaurantsListModel.swift
//  MVVMRxSwift
//
//  Created by YangJinMo on 2021/04/11.
//

import Foundation
import RxSwift

final class RestaurantsListModel {
  let title = "Restaurants"
  
  private let restaurantService: RestaurantServiceProtocol
  
  init(restaurantService: RestaurantServiceProtocol = RestaurantService()) {
    self.restaurantService = restaurantService
  }
  
  func fetchRestaurantViewModels() -> Observable<[RestaurantListModel]> {
    restaurantService.fetchRestaurants().map { $0.map { RestaurantListModel(restaurant: $0) } }
  }
}
