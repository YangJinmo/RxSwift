//
//  SearchViewController.swift
//  iTunesExplorer
//
//  Created by YangJinMo on 2021/04/21.
//

import AVFoundation
import AVKit
import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

// MARK: - Search View Controller

class SearchViewController: BaseMVVMViewController<SearchViewModel> {
  
  // MARK: - Constants
  
  /// Get local file path: download task stores tune here; AV player plays it.
  let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  let downloadService = DownloadService()
  let queryService = QueryService()
  
  // MARK: - Variables And Properties
  
  lazy var downloadsSession: URLSession = {
    let configuration = URLSessionConfiguration.background(withIdentifier: "com.raywenderlich.HalfTunes.bgSession")
    return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }()
  
  var searchResults: [Track] = []
  
  lazy var tapRecognizer: UITapGestureRecognizer = {
    var recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    return recognizer
  }()
  
  // MARK: - UI
  
  private let searchBar = UISearchBar().then {
    $0.placeholder = "Song name or artist"
    $0.searchBarStyle = .prominent
    $0.barStyle = .default
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
    $0.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.description)
  }
  
  // MARK: - Internal Methods
  
  @objc func dismissKeyboard() {
    searchBar.resignFirstResponder()
  }
  
  func localFilePath(for url: URL) -> URL {
    return documentsPath.appendingPathComponent(url.lastPathComponent)
  }
  
  func playDownload(_ track: Track) {
    guard let previewURL = track.previewUrl else { return }
    let playerViewController = AVPlayerViewController()
    present(playerViewController, animated: true, completion: nil)
    
    let url = localFilePath(for: previewURL)
    let player = AVPlayer(url: url)
    playerViewController.player = player
    player.play()
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
  
  func reload(_ row: Int) {
    collectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
  }
  
  // MARK: - View Controller
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureSubviews()
    configureConstraints()
    configureGesture()
    
    downloadService.downloadsSession = downloadsSession
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
  
  private func configureGesture() {
    searchBar.delegate = self
  }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    dismissKeyboard()
    
    guard let searchText = searchBar.text, !searchText.isEmpty else {
      return
    }
    
    queryService.getSearchResults(searchTerm: searchText) { [weak self] results, errorMessage in
      
      if let results = results {
        self?.searchResults = results
        self?.collectionView.delegate = self
        self?.collectionView.dataSource = self
        self?.collectionView.reloadData()
        self?.collectionView.setContentOffset(.zero, animated: false)
      }
      
      if !errorMessage.isEmpty {
        print("Search error: " + errorMessage)
      }
    }
    
    //getSearchResults(searchText: searchText)
  }
  
  func getSearchResults(searchText: String) {
    viewModel.getSearchResults(searchTerm: searchText)
    
    viewModel.track
      .asDriver()
      .drive(collectionView.rx.items(cellIdentifier: TrackCell.description)) { index, viewModel, cell in
        
        guard let trackCell: TrackCell = cell as? TrackCell else { return }
        guard let previewUrl = viewModel.previewUrl else { return }
        trackCell.delegate = self
        trackCell.configure(
          track: viewModel,
          download: self.downloadService.activeDownloads[previewUrl]
        )
      }
      .disposed(by: disposeBag)
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
    let track = searchResults[indexPath.row]
    
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
    
    return searchResults.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    
    let cell: TrackCell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.description, for: indexPath) as! TrackCell
    
    let track = searchResults[indexPath.row]
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
      let track = searchResults[indexPath.row]
      downloadService.cancelDownload(track)
      reload(indexPath.row)
    }
  }
  
  func downloadTapped(_ cell: TrackCell) {
    if let indexPath = collectionView.indexPath(for: cell) {
      let track = searchResults[indexPath.row]
      downloadService.startDownload(track)
      reload(indexPath.row)
    }
  }
  
  func pauseTapped(_ cell: TrackCell) {
    if let indexPath = collectionView.indexPath(for: cell) {
      let track = searchResults[indexPath.row]
      downloadService.pauseDownload(track)
      reload(indexPath.row)
    }
  }
  
  func resumeTapped(_ cell: TrackCell) {
    if let indexPath = collectionView.indexPath(for: cell) {
      let track = searchResults[indexPath.row]
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
    
    guard let url = downloadTask.originalRequest?.url,
          let download = downloadService.activeDownloads[url] else {
      return
    }
    
    download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    
    let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
    
    let index = searchResults.firstIndex { $0.previewUrl == download.track.previewUrl }
    print(index ?? "", download.track.index)
    
    DispatchQueue.main.async {
      let indexPath: IndexPath = IndexPath(row: download.track.index, section: 0)
      if let trackCell = self.collectionView.cellForItem(at: indexPath) as? TrackCell {
        trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
      }
    }
  }
}
