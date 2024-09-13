//
//  ChartListViewModel.swift
//  MusicPlayerApp
//
//  Created by Dustin Nuzzo on 13.09.24.
//

import Foundation
import SwiftUI

class ChartListViewModel: ObservableObject {
    @Published var songsArray: [ChartEntry] = [] // Array der geladene Songs speichert
    @Published var selectedType = "Songs" // Songs oder Alben auswählen
    @Published var selectedCountry = "de" // Standard DE
    
    let loadSongs = 50
    let chartTypes = ["Songs", "Alben"]
    
    //MARK: - Funktion um Listeneinträge neu zu laden, wenn Pickerauswahl getätigt wurde
    func reloadData() {
        // Liste leeren damit API neu lädt
        songsArray.removeAll()
        Task {
            await fetchScheduleFromAPI()
        }
    }
    
    //MARK: - Funktion zum Laden von Daten aus API
    func getScheduleFromAPI() async throws -> [ChartEntry] {
        let type = selectedType.lowercased() == "songs" ? "songs" : "albums"
        let urlString = "https://rss.applemarketingtools.com/api/v2/\(selectedCountry)/music/most-played/\(loadSongs)/\(type).json"
        
        guard let url = URL(string: urlString) else {
            throw HTTPError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let allSongs = try JSONDecoder().decode(APIResults.self, from: data).feed.results
        
        return allSongs
    }
    
    //MARK: - Funktion zum Aufruf der API Abfrage
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
