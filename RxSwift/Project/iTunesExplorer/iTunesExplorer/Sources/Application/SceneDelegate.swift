//
//  SceneDelegate.swift
//  iTunesExplorer
//
//  Created by Jmy on 2021/04/20.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Variables And Properties

    var appCoordinator: AppCoordinator?

    // MARK: - Lifecycle State Transitioning

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)

        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }
}
