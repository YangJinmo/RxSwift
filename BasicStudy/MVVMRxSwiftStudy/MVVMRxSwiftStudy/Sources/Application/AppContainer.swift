//
//  AppContainer.swift
//  MVVMRxSwiftStudy
//
//  Created by Jmy on 2021/04/20.
//

import UIKit

class AppContainer {
    static let instance: AppContainer = AppContainer()

    private lazy var restaurantService: RestaurantServiceProtocol = RestaurantService()

    private var restaurantListViewModel: RestaurantsListViewModel {
        return RestaurantsListViewModel(restaurantService: restaurantService)
    }

    var restaurantListViewController: RestaurantsListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateInitialViewController() as! RestaurantsListViewController
        viewController.viewModel = restaurantListViewModel // field injection
        // RestaurantsListViewController(viewModel: self.restaurantListViewModel) // constructor based injection
        return viewController
    }

    private init() {
    }
}
