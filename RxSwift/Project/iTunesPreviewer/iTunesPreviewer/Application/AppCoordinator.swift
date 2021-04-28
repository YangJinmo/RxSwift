//
//  AppCoordinator.swift
//  iTunesPreviewer
//
//  Created by YangJinMo on 2021/04/28.
//

import UIKit

final class AppCoordinator {
  
  // MARK: - Constants
  
  private let window: UIWindow
  
  // MARK: - Initialization
  
  init(window: UIWindow) {
    self.window = window
  }
  
  // MARK: - Internal Methods
  
  func start() {
    let viewController = AppContainer.instance.musicsViewController
    window.rootViewController = viewController
    window.makeKeyAndVisible()
  }
}
