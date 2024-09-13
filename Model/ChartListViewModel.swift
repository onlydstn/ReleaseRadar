//
//  ChartListViewModel.swift
//  MusicPlayerApp
//
//  Created by Dustin Nuzzo on 13.09.24.
//

import Foundation
import SwiftUI

@MainActor
class ChartListViewModel: ObservableObject {
    @Published var songsArray: [ChartEntry] = [] // Array saves loaded songs
    @Published var selectedType = "Songs" // Choose between songs and albums
    @Published var selectedCountry = "de" // Standard DE
    
    let loadSongsAmount = 50
    let chartTypes = ["Songs", "Alben"]
    
    //MARK: - Method to load new ListEntries when a selecton in the picker is made
    func reloadData() {
        // empty list so the API can reload
        songsArray.removeAll()
        Task {
            await fetchScheduleFromAPI()
        }
    }
    
    //MARK: - Method to load data from the API
    func getScheduleFromAPI() async throws -> [ChartEntry] {
        let type = selectedType.lowercased() == "songs" ? "songs" : "albums"
        let urlString = "https://rss.applemarketingtools.com/api/v2/\(selectedCountry)/music/most-played/\(loadSongsAmount)/\(type).json"
        
        guard let url = URL(string: urlString) else {
            throw HTTPError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let allSongs = try JSONDecoder().decode(APIResults.self, from: data).feed.results
        
        return allSongs
    }
    
    //MARK: - Method to call API
    func fetchScheduleFromAPI() async {
        do {
            // Lieder laden und offset anpassen
            let songs = try await getScheduleFromAPI()
            songsArray = songs // neue Lieder der Liste bzw. Array hinzufügen
        } catch  {
            print(HTTPError.fetchFailed.message, error)
        }
    }
}
