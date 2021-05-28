//
//  SearchViewModel.swift
//  iTunesPreviewer
//
//  Created by YangJinMo on 2021/04/28.
//

import RxSwift
import RxRelay

final class MusicsViewModel: BaseViewModel {
  
  // MARK: - Private Constants
  
  private let queryService: QueryServiceProtocol
  
  // MARK: - Private Variables
  
  private var musics: PublishSubject<[Music]> = .init()
  
  // MARK: - Variables And Properties
  
  var musicsObservable: Observable<[Music]> {
    return musics.asObservable()
  }
  
  // MARK: - Initialization
  
  init(queryService: QueryServiceProtocol = QueryService()) {
    self.queryService = queryService
  }
  
  // MARK: - Internal Methods
  
  func getSearchResults(searchTerm: String) {
    queryService.getSearchResults(searchTerm: searchTerm)
      .bind(to: musics)
      .disposed(by: disposeBag)
  }
}
