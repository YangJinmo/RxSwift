//
//  DownloadService.swift
//  iTunesExplorer
//
//  Created by Jmy on 2021/04/21.
//

import Foundation

/// Downloads song snippets, and stores in local file.
/// Allows cancel, pause, resume download.
class DownloadService {
    // MARK: - Variables And Properties

    var activeDownloads: [URL: Download] = [:]

    /// SearchViewController creates downloadsSession
    var downloadsSession: URLSession!

    // MARK: - Internal Methods

    func cancelDownload(_ track: Track) {
        guard
            let previewUrl = track.previewUrl,
            let download = activeDownloads[previewUrl]
        else {
            return
        }
        download.task?.cancel()

        activeDownloads[previewUrl] = nil
    }

    func pauseDownload(_ track: Track) {
        guard
            let previewUrl = track.previewUrl,
            let download = activeDownloads[previewUrl], download.isDownloading
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
            let previewUrl = track.previewUrl,
            let download = activeDownloads[previewUrl],
            let downloadUrl = download.track.previewUrl
        else {
            return
        }

        if let resumeData = download.resumeData {
            download.task = downloadsSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = downloadsSession.downloadTask(with: downloadUrl)
        }

        download.task?.resume()
        download.isDownloading = true
    }

    func startDownload(_ track: Track) {
        let download = Download(track: track)
        guard
            let previewUrl = track.previewUrl,
            let downloadUrl = download.track.previewUrl
        else {
            return
        }
        download.task = downloadsSession.downloadTask(with: previewUrl)
        download.task?.resume()
        download.isDownloading = true

        activeDownloads[downloadUrl] = download
    }
}
