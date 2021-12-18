//
//  Music.swift
//  iTunesPreviewer
//
//  Created by Jmy on 2021/04/28.
//

import Foundation

struct Music: Decodable {
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let artworkUrl60: URL?
    let artworkUrl100: URL?
    let previewUrl: URL?
    let isStreamable: Bool?
}
