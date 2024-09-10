//
//  ChartItem.swift
//  MusicPlayerApp
//
//  Created by Dustin Nuzzo on 10.09.24.
//

import Foundation

struct ChartItem: Identifiable {
    var id = UUID()
    
    var position: Int
    var albumCover: String
    var songTitle: String
    var artist: String
    var streams: String
}
