//
//  ChartItem.swift
//  MusicPlayerApp
//
//  Created by Dustin Nuzzo on 10.09.24.
//

import Foundation

//Dummy
//struct ChartEntry: Codable {
//    var position: Int
//    var albumCover: String
//    var songTitle: String
//    var artist: String
//    var streams: String
//}

//Modell
struct ChartEntry: Codable, Hashable {
    var name: String // Liedname
    var artistName: String // Name des Künstlers
    var releaseDate: String
    var artworkUrl100: String // Cover
    var url: String // Link zum Song
}

struct APIResults: Codable {
    var feed: Feed
}

struct Feed: Codable {
    var results: [ChartEntry]
}
