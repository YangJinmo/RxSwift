//
//  DownloadService.swift
//  iTunesExplorer
//
//  Created by YangJinMo on 2021/04/21.
//

import Foundation

/// Downloads song snippets, and stores in local file.
/// Allows cancel, pause, resume download.
class DownloadService {
  
  // MARK: - Variables And Properties
  
  var activeDownloads: [URL: Download] = [ : ]
  
  /// SearchViewController creates downloadsSession
  var downloadsSession: URLSession!
  
  // MARK: - Internal Methods
  
  func cancelDownload(_ track: Track) {
    guard let download = activeDownloads[track.previewURL] else {
      return
    }
    download.task?.cancel()

    activeDownloads[track.previewURL] = nil
  }
  
  func pauseDownload(_ track: Track) {
    guard
      let download = activeDownloads[track.previewURL],
      download.isDownloading
      else {
        return
    }
    
    download.task?.cancel(byProducingResumeData: { data in
      download.resumeData = data
    })

    download.isDownloading = false
  }
  
  func resumeDownload(_ track: Track) {
    guard let download = activeDownloads[track.previewURL] else {
      return
    }
    
    if let resumeData = download.resumeData {
      download.task = downloadsSession.downloadTask(withResumeData: resumeData)
    } else {
      download.task = downloadsSession.downloadTask(with: download.track.previewURL)
    }
    
    download.task?.resume()
    download.isDownloading = true
  }
  
  func startDownload(_ track: Track) {
    // 1
    let download = Download(track: track)
    // 2
    download.task = downloadsSession.downloadTask(with: track.previewURL)
    // 3
    download.task?.resume()
    // 4
    download.isDownloading = true
    // 5
    activeDownloads[download.track.previewURL] = download
  }
}
