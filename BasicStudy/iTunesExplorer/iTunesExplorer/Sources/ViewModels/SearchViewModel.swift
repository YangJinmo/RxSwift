//
//  SearchViewModel.swift
//  iTunesExplorer
//
//  Created by Jmy on 2021/04/21.
//

import RxRelay
import RxSwift

final class SearchViewModel: BaseViewModel {
    private let queryService: QueryServiceProtocol
    
    let title: BehaviorRelay<String> = .init(value: "SearchViewModel")
    let track: BehaviorRelay<[Track]> = .init(value: [])

    // MARK: - Initialization

    init(queryService: QueryServiceProtocol = QueryService()) {
        self.queryService = queryService
    }

    // MARK: - Methods

    override func start() {
    }

    func getSearchResults(searchTerm: String) {
        queryService.getSearchResults(searchTerm: searchTerm)
            .bind(to: track)
            .disposed(by: disposeBag)
    }
}
