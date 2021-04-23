//
//  SceneDelegate.swift
//  iTunesExplorer
//
//  Created by YangJinMo on 2021/04/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // MARK: - Variables And Properties
  
  var window: UIWindow?
  var appCoordinator: AppCoordinator?
  
  // MARK: - Lifecycle State Transitioning
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    
    let window = UIWindow(windowScene: scene)
    
    appCoordinator = AppCoordinator(window: window)
    appCoordinator?.start()
  }
}
