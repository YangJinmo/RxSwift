//
//  SceneDelegate.swift
//  MVVMRxSwift
//
//  Created by Jmy on 2021/04/08.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)

        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }
}
