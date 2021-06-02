//
//  RestaurantListModel.swift
//  MVVMRxSwift
//
//  Created by Jmy on 2021/04/11.
//

import Foundation

struct RestaurantListModel {
  
  private let restaurant: Restaurant
  
  var displayText: String {
    return restaurant.name + " - " + restaurant.cuisine.rawValue.capitalized
  }
  
  init(restaurant: Restaurant) {
    self.restaurant = restaurant
  }
}
