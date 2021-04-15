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
  
  /*
   the default argument for this is simply going to be our restaurant service
   now why would you not just inject the restaurant service
   when it comes to unit testing our view model
   
   we want to be able to abstract away the fetchRestaurants method
   so we can return some fake data
   and we don't have to test this method along with our view model
   */
  init(restaurantService: RestaurantServiceProtocol = RestaurantService()) {
    self.restaurantService = restaurantService
  }
  
  /*
   come down to the fetchRestaurantViewModels method
   and if you remember this restaurant service will be sending us a stream of restaurants
   when we subscribe to this fetchRestaurants method
   but we actually want to send to the view controller is this array of restaurant view models

   so we need some way to convert the restaurants into this stream of restaurant view models
   and we're going to use the operator map

   now we need to RxSwift
   so it knows about this obseverble type
   so after fetchRestaurants we're going to call dot map
   and this will mean that we can access our array of reataurants

   so this dollar zero shorthand will be an array of restaurants
   we then need to map through this away
   and convert each item ie the restaurant into a restaurant view model

   and if you remember we had an initializer that takes a restaurant
   so we can again use the dollar zero which is the restaurant
   */
  func fetchRestaurantViewModels() -> Observable<[RestaurantListModel]> {
    restaurantService.fetchRestaurants().map { $0.map { RestaurantListModel(restaurant: $0) } }
  }
}
