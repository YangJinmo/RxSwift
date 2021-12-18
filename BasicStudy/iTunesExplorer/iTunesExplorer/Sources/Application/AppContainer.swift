//
//  AppContainer.swift
//  iTunesExplorer
//
//  Created by Jmy on 2021/04/20.
//

import UIKit

final class AppContainer {
    static let instance: AppContainer = AppContainer()
    private lazy var queryService: QueryServiceProtocol = QueryService()

    private var searchViewModel: SearchViewModel {
        return SearchViewModel(queryService: queryService)
    }

    var searchViewController: SearchViewController {
        return SearchViewController(viewModel: searchViewModel)
    }
}
