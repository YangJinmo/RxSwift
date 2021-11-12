//
//  AppCoordinator.swift
//  MVVMRxSwift
//
//  Created by Jmy on 2021/04/09.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewController = ViewController.instantiate(viewModel: RestaurantsListModel())
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
