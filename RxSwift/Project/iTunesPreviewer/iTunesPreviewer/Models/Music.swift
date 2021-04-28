//
//  Music.swift
//  iTunesPreviewer
//
//  Created by YangJinMo on 2021/04/28.
//

import Foundation

struct Music: Decodable {
  let trackName: String
  let artistName: String
  let collectionName: String
  let artworkUrl60: String
  let artworkUrl100: String
  let previewUrl: String
  let isStreamable: Bool
}
