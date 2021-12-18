//
//  AppCoordinator.swift
//  iTunesPreviewer
//
//  Created by Jmy on 2021/04/28.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow

    // MARK: - Initialization

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Methods

    func start() {
        let viewController = AppContainer.instance.musicsViewController
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
