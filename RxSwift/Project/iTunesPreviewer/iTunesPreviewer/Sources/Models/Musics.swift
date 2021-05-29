//
//  Musics.swift
//  iTunesPreviewer
//
//  Created by Jmy on 2021/04/28.
//

import Foundation

struct Musics: Decodable {
  let resultCount: Int
  let results: [Music]
}
