//
//  SearchViewController.swift
//  iTunesExplorer
//
//  Created by Jmy on 2021/04/21.
//

import AVFoundation
import AVKit
import RxCocoa
import RxRelay
import RxSwift
import SnapKit
import Then
import UIKit

final class SearchViewController: BaseMVVMViewController<SearchViewModel> {
    /// Get local file path: download task stores tune here; AV player plays it.
    private let documentsPath: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let downloadService = DownloadService()
    private let queryService = QueryService()
    private let cellHeight: CGFloat = 116

    private lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.raywenderlich.HalfTunes.bgSession")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    private var tracks: [Track] = []

    // MARK: - UI

    private let searchBar = UISearchBar().then {
        $0.placeholder = "Song name or artist"
        $0.searchBarStyle = .prominent
        $0.barStyle = .default
    }

    private lazy var collectionView = BaseCollectionView(layout: flowLayout()).then {
        $0.dataSource = self
        $0.delegate = self
        $0.register(TrackCell.self)
    }

    // MARK: - Action

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return recognizer
    }()

    // MARK: - Methods

    @objc private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    private func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }

    private func playDownload(_ track: Track) {
        guard let previewURL = track.previewUrl else { return }
        let playerViewController = AVPlayerViewController()
        present(playerViewController, animated: true, completion: nil)

        let url = localFilePath(for: previewURL)
        let player = AVPlayer(url: url)
        playerViewController.player = player
        player.play()
    }

    private func reload(_ row: Int) {
        collectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
    }

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

    override func loadView() {
        super.loadView()

        setupViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self

        downloadService.downloadsSession = downloadsSession
    }

    // MARK: - Methods

    private func setupViews() {
        view.addSubviews(
            searchBar,
            collectionView
        )

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()

        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }

        queryService.getResults(path: .search, term: searchText) { [weak self] tracks, errorMessage in
            if let tracks = tracks {
                self?.tracks = tracks
                self?.collectionView.reloadData()
                self?.collectionView.setContentOffset(.zero, animated: false)
            }

            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
            }
        }

        // getSearchResults(searchText: searchText)
    }

    func getSearchResults(searchText: String) {
        viewModel.getSearchResults(searchTerm: searchText)

        viewModel.track
            .asDriver()
            .drive(collectionView.rx.items(cellIdentifier: TrackCell.reuseIdentifier)) { _, viewModel, cell in
                guard
                    let trackCell: TrackCell = cell as? TrackCell,
                    let previewUrl = viewModel.previewUrl
                else {
                    return
                }
                trackCell.delegate = self
                trackCell.configure(
                    track: viewModel,
                    download: self.downloadService.activeDownloads[previewUrl]
                )
            }
            .disposed(by: disposeBag)

//    collectionView.rx.itemSelected
//      .subscribe(onNext: { index in
//        print("\(index.section) \(index.row)")
//      })
//      .disposed(by: disposeBag)
//
//    collectionView.rx.setDelegate(self)
//      .disposed(by: disposeBag)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let track = tracks[indexPath.row]

        if track.downloaded {
            playDownload(track)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return tracks.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: TrackCell = collectionView.dequeueReusableCell(for: indexPath)

        let track = tracks[indexPath.row]
        guard let previewUrl = track.previewUrl else { return cell }
        cell.configure(track: track, download: downloadService.activeDownloads[previewUrl])
        cell.delegate = self

        return cell
    }
}

// MARK: - TrackCellDelegate

extension SearchViewController: TrackCellDelegate {
    func cancelTapped(_ cell: TrackCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let track = tracks[indexPath.row]
            downloadService.cancelDownload(track)
            reload(indexPath.row)
        }
    }

    func downloadTapped(_ cell: TrackCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let track = tracks[indexPath.row]
            downloadService.startDownload(track)
            reload(indexPath.row)
        }
    }

    func pauseTapped(_ cell: TrackCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let track = tracks[indexPath.row]
            downloadService.pauseDownload(track)
            reload(indexPath.row)
        }
    }

    func resumeTapped(_ cell: TrackCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let track = tracks[indexPath.row]
            downloadService.resumeDownload(track)
            reload(indexPath.row)
        }
    }
}

// MARK: - URLSessionDelegate

extension SearchViewController: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                completionHandler()
            }
        }
    }
}

// MARK: - URLSessionDownloadDelegate

extension SearchViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        guard let sourceURL = downloadTask.originalRequest?.url else {
            return
        }

        let download = downloadService.activeDownloads[sourceURL]
        downloadService.activeDownloads[sourceURL] = nil

        let destinationURL = localFilePath(for: sourceURL)
        print(destinationURL)

        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)

        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            download?.track.downloaded = true
        } catch {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }

        if let index = download?.track.index {
            DispatchQueue.main.async { [weak self] in
                let indexPath: IndexPath = IndexPath(row: index, section: 0)
                self?.collectionView.reloadItems(at: [indexPath])
            }
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        guard
            let url = downloadTask.originalRequest?.url,
            let download = downloadService.activeDownloads[url]
        else {
            return
        }

        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)

        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)

//    let index = searchResults.firstIndex { $0.previewUrl == download.track.previewUrl }
//    let searchResultsIndex = index ?? -1
//
//    guard searchResults.indices.contains(searchResultsIndex) else {
//      print("searchResults isIndexValid = false")
//      return
//    }
//    "\(searchResultsIndex)".log()

        DispatchQueue.main.async {
            // let indexPath: IndexPath = IndexPath(row: searchResultsIndex, section: 0)
            let indexPath: IndexPath = IndexPath(row: download.track.index, section: 0)
            if let trackCell = self.collectionView.cellForItem(at: indexPath) as? TrackCell {
                trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize(width: collectionView, height: cellHeight)
    }
}

// MARK: - FlowLayoutMetric

extension SearchViewController: FlowLayoutMetric {
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
