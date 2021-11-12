//
//  Track.swift
//  iTunesExplorer
//
//  Created by Jmy on 2021/04/21.
//

import Foundation.NSURL

/// Query service creates Track objects
class Track: Decodable {
    // MARK: - Constants

    let trackName: String?
    let artistName: String?
    let artworkUrl100: URL?
    let previewUrl: URL?
    let index: Int

    // MARK: - Variables And Properties

    var downloaded = false

    // MARK: - Initialization

    init(trackName: String?, artistName: String?, artworkUrl100: URL?, previewUrl: URL?, index: Int) {
        self.trackName = trackName
        self.artistName = artistName
        self.artworkUrl100 = artworkUrl100
        self.previewUrl = previewUrl
        self.index = index
    }

    init(json: [String: Any], index: Int) {
        trackName = json["trackName"] as? String
        artistName = json["artistName"] as? String
        artworkUrl100 = (json["artworkUrl100"] as? String).flatMap { URL(string: $0) }
        previewUrl = (json["previewUrl"] as? String).flatMap { URL(string: $0) }
        self.index = index
    }
}
