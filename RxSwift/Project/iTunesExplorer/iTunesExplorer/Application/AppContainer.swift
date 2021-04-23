//
//  AppContainer.swift
//  iTunesExplorer
//
//  Created by YangJinMo on 2021/04/20.
//

import UIKit

class AppContainer {
  
  // MARK: - Constants
  
  static let instance: AppContainer = AppContainer()
  
  // MARK: - Variables And Properties
  
  private lazy var queryService: QueryServiceProtocol = QueryService()
  
  // MARK: - Private Properties
  
  private var searchViewModel: SearchViewModel {
    return SearchViewModel(queryService: queryService)
  }
  
  // MARK: - Internal Properties
  
  var searchViewController: SearchViewController {
    return SearchViewController(viewModel: searchViewModel)
  }
}
