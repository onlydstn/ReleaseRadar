//
//  ChartItem.swift
//  MusicPlayerApp
//
//  Created by Dustin Nuzzo on 10.09.24.
//

import Foundation

//Modell
struct ChartEntry: Codable, Identifiable {
    var id: String
    
    var name: String // songname
    var artistName: String // artistname
    var releaseDate: String? // releasedate
    var artworkUrl100: String // artwork link
    var url: String // link to apple music
}
