//
//  Download.swift
//  iTunesExplorer
//
//  Created by Jmy on 2021/04/21.
//

import Foundation

class Download {
    var isDownloading = false
    var progress: Float = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    var track: Track

    // MARK: - Initialization

    init(track: Track) {
        self.track = track
    }
}
