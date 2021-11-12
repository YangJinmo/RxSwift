//
//  MusicsViewModel.swift
//  iTunesPreviewer
//
//  Created by Jmy on 2021/04/28.
//

import RxRelay
import RxSwift

final class MusicsViewModel: BaseViewModel {
    private let queryService: QueryServiceProtocol
    private var musics: PublishSubject<[Music]> = .init()
    
    var musicsObservable: Observable<[Music]> {
        return musics.asObservable()
    }

    // MARK: - Initialization

    init(queryService: QueryServiceProtocol = QueryService()) {
        self.queryService = queryService
    }

    // MARK: - Methods

    func getSearchResults(searchTerm: String) {
        queryService.getSearchResults(searchTerm: searchTerm)
            .bind(to: musics)
            .disposed(by: disposeBag)
    }
}
