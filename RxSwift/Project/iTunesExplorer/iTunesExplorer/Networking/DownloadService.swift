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
    guard
      let previewURL = track.previewURL,
      let download = activeDownloads[previewURL]
    else {
      return
    }
    download.task?.cancel()
    
    activeDownloads[previewURL] = nil
  }
  
  func pauseDownload(_ track: Track) {
    guard
      let previewURL = track.previewURL,
      let download = activeDownloads[previewURL], download.isDownloading
    else {
      return
    }
    
    download.task?.cancel(byProducingResumeData: { data in
      download.resumeData = data
    })
    
    download.isDownloading = false
  }
  
  func resumeDownload(_ track: Track) {
    guard
      let previewURL = track.previewURL,
      let download = activeDownloads[previewURL],
      let downloadURL = download.track.previewURL
    else {
      return
    }
    
    if let resumeData = download.resumeData {
      download.task = downloadsSession.downloadTask(withResumeData: resumeData)
    } else {
      download.task = downloadsSession.downloadTask(with: downloadURL)
    }
    
    download.task?.resume()
    download.isDownloading = true
  }
  
  func startDownload(_ track: Track) {
    let download = Download(track: track)
    guard
      let previewURL = track.previewURL,
      let downloadURL = download.track.previewURL
    else {
      return
    }
    download.task = downloadsSession.downloadTask(with: previewURL)
    download.task?.resume()
    download.isDownloading = true
    
    activeDownloads[downloadURL] = download
  }
}
