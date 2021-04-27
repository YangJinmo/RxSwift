//
//  Track.swift
//  iTunesExplorer
//
//  Created by YangJinMo on 2021/04/21.
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
/*
{"wrapperType":"track", "kind":"song", "artistId":409076743, "collectionId":409076726, "trackId":409076748, "artistName":"IU", "collectionName":"Real", "trackName":"Good Day", "collectionCensoredName":"Real", "trackCensoredName":"Good Day", "artistViewUrl":"https://music.apple.com/us/artist/iu/409076743?uo=4", "collectionViewUrl":"https://music.apple.com/us/album/good-day/409076726?i=409076748&uo=4", "trackViewUrl":"https://music.apple.com/us/album/good-day/409076726?i=409076748&uo=4", "previewUrl":"https://audio-ssl.itunes.apple.com/itunes-assets/Music/v4/ae/7c/db/ae7cdbef-b276-f46b-03cb-c499d9ebc43c/mzaf_7324927432527237367.plus.aac.p.m4a", "artworkUrl30":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/b3/5d/dd/b35ddda8-6651-37f8-1316-d33b35018ccf/source/30x30bb.jpg", "artworkUrl60":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/b3/5d/dd/b35ddda8-6651-37f8-1316-d33b35018ccf/source/60x60bb.jpg", "artworkUrl100":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/b3/5d/dd/b35ddda8-6651-37f8-1316-d33b35018ccf/source/100x100bb.jpg", "collectionPrice":6.93, "trackPrice":0.99, "releaseDate":"2010-12-09T08:00:00Z", "collectionExplicitness":"notExplicit", "trackExplicitness":"notExplicit", "discCount":1, "discNumber":1, "trackCount":7, "trackNumber":3, "trackTimeMillis":233563, "country":"USA", "currency":"USD", "primaryGenreName":"K-Pop", "isStreamable":true},
*/
