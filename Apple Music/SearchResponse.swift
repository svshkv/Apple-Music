//
//  SearchResponse.swift
//  Apple Music
//
//  Created by Саша Руцман on 17/09/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String?
    var collectionName: String?
    var artistName: String
    var artworkUrl100: String?
}

