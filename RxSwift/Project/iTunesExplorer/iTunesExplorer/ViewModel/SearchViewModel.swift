//
//  SearchViewModel.swift
//  iTunesExplorer
//
//  Created by YangJinMo on 2021/04/21.
//

import Foundation
import RxSwift
import RxRelay

final class SearchViewModel: BaseViewModel {
  
  // MARK: - Constants
  
  private let queryService: QueryServiceProtocol
  
  let title: BehaviorRelay<String> = .init(value: "SearchViewModel")
  let track: BehaviorRelay<[Track]> = .init(value: [])
  
  // MARK: - Initialization
  
  init(queryService: QueryServiceProtocol = QueryService()) {
    self.queryService = queryService
  }
  
  // MARK: - Internal Methods
  
  override func start() {
    
  }
  
  func getSearchResults(searchTerm: String) {
    queryService.getSearchResults(searchTerm: searchTerm)
      .bind(to: track)
      .disposed(by: disposeBag)
  }
}
