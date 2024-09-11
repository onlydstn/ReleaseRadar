//
//  HTTPError.swift
//  MusicPlayerApp
//
//  Created by Dustin Nuzzo on 11.09.24.
//

import Foundation

enum HTTPError: Error {
    case invalidURL, fetchFailed
    
    var message: String {
        switch self {
        case .invalidURL: "Die URL ist ungültig."
        case .fetchFailed: "Fehler beim Laden der API-Daten."
        }
    }
}
