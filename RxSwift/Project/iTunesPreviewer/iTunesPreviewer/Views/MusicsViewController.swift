//
//  MusicsViewController.swift
//  iTunesPreviewer
//
//  Created by YangJinMo on 2021/04/28.
//

import AVFoundation
import AVKit
import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

final class MusicsViewController: BaseMVVMViewController<MusicsViewModel> {
  
  // MARK: - UI
  
  private let searchBar = UISearchBar().then {
    $0.placeholder = "Song name or artist"
  }
  
  private let collectionViewLayout = UICollectionViewFlowLayout().then {
    let numberOfItemForRow: CGFloat = 1
    let lineSpacing: CGFloat = 0
    let interItemSpacing: CGFloat = 0
    let inset: CGFloat = 0
    let viewWidth: CGFloat = UIScreen.width
    let collectionWidth: CGFloat = viewWidth - (inset * 2)
    let cellWidth: CGFloat = (collectionWidth - (interItemSpacing * (numberOfItemForRow - 1))) / numberOfItemForRow
    let cellHeight: CGFloat = 116
    
    $0.itemSize = CGSize(width: cellWidth, height: cellHeight)
    $0.sectionInset = .init(top: 0, left: inset, bottom: 0, right: inset)
    $0.scrollDirection = .vertical
    $0.minimumLineSpacing = lineSpacing
    $0.minimumInteritemSpacing = interItemSpacing
  }
  
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: collectionViewLayout
  ).then {
    $0.showsHorizontalScrollIndicator = false
    $0.showsVerticalScrollIndicator = false
    $0.backgroundColor = .systemBackground
    $0.alwaysBounceVertical = true
    $0.register(MusicCell.self, forCellWithReuseIdentifier: MusicCell.description)
  }
  
  // MARK: - Internal Methods
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
  
  // MARK: - View Controller
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureSubviews()
    configureConstraints()
    
    bind()
  }
  
  // MARK: - Configuring
  
  private func configureSubviews() {
    view.addSubviews(
      searchBar,
      collectionView
    )
  }
  
  private func configureConstraints() {
    searchBar.snp.makeConstraints {
      $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
    }
    collectionView.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom)
      $0.left.right.equalTo(view.safeAreaLayoutGuide)
      $0.bottom.equalToSuperview()
    }
  }
  
  private func bind() {
    
    // MARK: - Search Bar
    
    searchBar.rx.text.orEmpty
      //.throttle(.seconds(3), scheduler: MainScheduler.instance)
      .debounce(.seconds(1), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] searchTerm in
        guard let self = self else { return }
        self.viewModel.getSearchResults(searchTerm: searchTerm)
      })
      .disposed(by: disposeBag)
    
    searchBar.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    // MARK: - Collection View
    
    viewModel.musicsObservable
      .asDriver(onErrorJustReturn: [])
      .drive(collectionView.rx.items(cellIdentifier: MusicCell.description)) { index, music, cell in
        guard let cell = cell as? MusicCell else { return }
        cell.bind(music: music)
      }
      .disposed(by: disposeBag)
    
    collectionView.rx.modelSelected(Music.self)
      .subscribe(onNext: { music in
        let vc = PlayerViewController(music: music)
        self.present(vc, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - UISearchBarDelegate
extension MusicsViewController: UISearchBarDelegate {
}
