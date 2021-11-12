//
//  MusicsViewController.swift
//  iTunesPreviewer
//
//  Created by Jmy on 2021/04/28.
//

import AVFoundation
import AVKit
import RxCocoa
import RxRelay
import RxSwift
import SnapKit
import Then
import UIKit

final class MusicsViewController: BaseMVVMViewController<MusicsViewModel> {
    // MARK: - Constants

    private let cellHeight: CGFloat = 116

    // MARK: - UI

    private let searchBar = UISearchBar().then {
        $0.placeholder = "Song name or artist"
    }

    private lazy var collectionView = BaseCollectionView(layout: flowLayout()).then {
        $0.register(MusicCell.self)
    }

    // MARK: - Internal Methods

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

    // MARK: - UIViewController Transition Coordinator

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }

    // MARK: - View Life Cycle

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
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    private func bind() {
        // MARK: - Search Bar

        searchBar.rx.text.orEmpty
            // .throttle(.seconds(3), scheduler: MainScheduler.instance)
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
            .drive(collectionView.rx.items(cellIdentifier: MusicCell.reuseIdentifier)) { _, music, cell in
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

        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - UISearchBarDelegate

extension MusicsViewController: UISearchBarDelegate {
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MusicsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize(width: collectionView, height: cellHeight)
    }
}

// MARK: - FlowLayoutMetric

extension MusicsViewController: FlowLayoutMetric {
    var numberOfItemForRow: CGFloat {
        1
    }

    var inset: CGFloat {
        0
    }

    var lineSpacing: CGFloat {
        0
    }

    var interItemSpacing: CGFloat {
        0
    }
}
