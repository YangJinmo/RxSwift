//
//  Restaurant.swift
//  MVVMRxSwiftStudy
//
//  Created by Jmy on 2021/04/09.
//

import Foundation

struct Restaurant: Decodable {
  let name: String
  let cuisine: Cuisine
  
  var displayText: String {
    return name + " - " + cuisine.rawValue.capitalized
  }
}

enum Cuisine: String, Decodable {
  case european
  case indian
  case mexican
  case french
  case english
}
