//
//  APIResultsModel.swift
//  MusicPlayerApp
//
//  Created by Dustin Nuzzo on 13.09.24.
//

import Foundation

struct APIResults: Codable {
    var feed: Feed
}

struct Feed: Codable {
    var results: [ChartEntry]
}
