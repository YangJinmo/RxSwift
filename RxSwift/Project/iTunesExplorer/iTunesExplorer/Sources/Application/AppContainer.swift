//
//  AppContainer.swift
//  iTunesExplorer
//
//  Created by Jmy on 2021/04/20.
//

import UIKit

final class AppContainer {
    // MARK: - Constants

    static let instance: AppContainer = AppContainer()

    // MARK: - Private Variables And Properties

    private lazy var queryService: QueryServiceProtocol = QueryService()

    private var searchViewModel: SearchViewModel {
        return SearchViewModel(queryService: queryService)
    }

    // MARK: - Internal Properties

    var searchViewController: SearchViewController {
        return SearchViewController(viewModel: searchViewModel)
    }
}
