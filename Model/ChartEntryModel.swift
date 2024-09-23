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
    
    var hdArtworkUrl: URL? { // create a string segment and replace the resolution to 1024x1024 for better artwork quality
        if let lastSlashIndex = artworkUrl100.lastIndex(of: "/") { // url segmented to everything past the last "/"
            let baseURL = artworkUrl100[..<lastSlashIndex] // url segmented to everything before the last "/"
            let modifiedURLString = "\(baseURL)/1024x1024bb.jpg" // new modified url to contain only baseURL and added resolution
            return URL(string: modifiedURLString) // complete new url with modified resolution
        }
        return nil
    }
}
