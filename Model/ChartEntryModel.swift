//
//  ChartItem.swift
//  MusicPlayerApp
//
//  Created by Dustin Nuzzo on 10.09.24.
//

import Foundation

//Modell
struct ChartEntry: Codable, Identifiable {
    let id: String
    
    let name: String // songname
    let artistName: String // artistname
    let releaseDate: String // releasedate
    let artworkUrl100: String // artwork link
    let url: String // link to apple music
}
