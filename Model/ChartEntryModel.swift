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
    
    let name: String // Liedname
    let artistName: String // Name des Künstlers
    let releaseDate: String
    let artworkUrl100: String // Cover
    let url: String // Link zum Song
}
