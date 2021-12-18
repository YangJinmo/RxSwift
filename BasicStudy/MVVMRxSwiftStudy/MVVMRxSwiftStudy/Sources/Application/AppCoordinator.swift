//
//  AppCoordinator.swift
//  MVVMRxSwiftStudy
//
//  Created by Jmy on 2021/04/20.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewController = AppContainer.instance.restaurantListViewController
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
