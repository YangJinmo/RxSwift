//
//  AppContainer.swift
//  iTunesPreviewer
//
//  Created by Jmy on 2021/04/28.
//

import UIKit

final class AppContainer {
    static let instance: AppContainer = AppContainer()
    private lazy var queryService: QueryServiceProtocol = QueryService()

    private var musicsViewModel: MusicsViewModel {
        return MusicsViewModel(queryService: queryService)
    }

    var musicsViewController: MusicsViewController {
        return MusicsViewController(viewModel: musicsViewModel)
    }
}
