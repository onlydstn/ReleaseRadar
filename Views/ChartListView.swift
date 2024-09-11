//
//  ChartListView.swift
//  MusicPlayerApp
//
//  Created by Dustin Nuzzo on 10.09.24.
//

import SwiftUI

//MARK: - TabView
struct MainTabView: View {
    var body: some View {
        TabView {
            ChartListView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Charts")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Suche")
                }
        }
    }
}

//MARK: - ChartListView
struct ChartListView: View {
    @State var songsArray: [ChartEntry] = [] // Array der geladene Songs speichert
    @State var isLoadingMore = false // verhindert, dass mehrere API-Abfragen gleichzeitig stattfinden
    @State var offset = 0 // legt das Offset für Paginierung fest, also den Startpunkt des Ladens
    @State var limit = 5 // Anzahl der Einträge, die pro API-Aufruf geladen werden sollen
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(songsArray.enumerated()), id: \.element.id) { index, item in
                    //MARK: Albumcover Link
                    let str = item.artworkUrl100
                    let url = URL(string: str)
                    
                    HStack {
                        /// Chartposition
                        HStack {
                            Text("#\(index + 1)")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .foregroundStyle(.purple.opacity(0.3))
                                .padding(.trailing)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 12) {
                                    /// Songtitel
                                    Text("\(item.name)")
                                        .font(.headline)
                                    
                                    /// Name des Künstlers
                                    Text("\(item.artistName)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    /// Releasedate
                                    Text(item.releaseDate)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                
                                /// Albumcover
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .frame(width: 95, height: 95)
                                        .cornerRadius(8)
                                } placeholder: {
                                    Image("placeholder")
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        //öffnet Titel in Apple Music
                        .onTapGesture {
                            UIApplication.shared.open(URL(string: "\(item.url)")!)
                        }
                    }
                    .listRowBackground(Color(.clear))
                    
                    // If-Abfrage prüft, ob das letzte Element in der Liste erreciht wurde...
                    if index == songsArray.count - 1 {
                        Color.clear
                            .onAppear {
                                loadMoreListEntries() // und lädt neue Einträge wenn das Ende der Liste erreicht wurde
                            }
                    }
                }
                .navigationTitle("Charts")
            }
            .listStyle(PlainListStyle())
            .background(Color(.systemGray6).opacity(0.5))
        }
        .task {
            // Lieder beim ersten Laden der Ansicht über API-Abfrage holen
            await fetchScheduleFromAPI()
        }
    }
    
    //MARK: - Funktion zum Laden neuer Listeneinträge
    private func loadMoreListEntries() {
        // verhindern dass API mehrfach bzw. gleichzeitig aufgerufen wird indem es isLoadingMore prüft
        guard !isLoadingMore else { return }
        
        isLoadingMore = true
        Task {
            do {
                // lade mehr Lieder basierend auf Offset und Limit
                let moreSongs = try await getScheduleFromAPI(offset: offset, limit: limit)
                songsArray.append(contentsOf: moreSongs) // neue Lieder der Liste bzw. Array hinzufügen
                offset += limit // Offset erhöhen, um die nächsten EIntäge zu laden
            } catch {
                print("Fehler beim Laden neuer Lieder: \(error)")
            }
            isLoadingMore = false
        }
    }
    
    //MARK: - Funkton zum Laden der lokalen JSON
    private func fetchSongsFromJSON() {
        guard let path = Bundle.main.path(forResource: "charts", ofType: "json") else {
            print("File doesn't exist")
            return
        }
        do {
            let data = try Data(contentsOf: URL(filePath: path))
            let songs = try JSONDecoder().decode(APIResults.self, from: data)
            
            self.songsArray = songs.feed.results
        } catch {
            print("Error: \(error)")
            return
        }
    }
    
    //MARK: - Funktion zum Laden von Daten aus API
    private func getScheduleFromAPI(offset: Int, limit: Int) async throws -> [ChartEntry] {
        let urlString = "https://rss.applemarketingtools.com/api/v2/de/music/most-played/50/songs.json"
        
        guard let url = URL(string: urlString) else {
            throw HTTPError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let allSongs = try JSONDecoder().decode(APIResults.self, from: data).feed.results
        // nur Bereich von Offset bis Limit zurückgeben (also 0+5)
        let paginatedSongs = Array(allSongs[offset..<min(offset + limit, allSongs.count)])
        return paginatedSongs
    }
    
    //MARK: - Funktion zum Aufruf der API Abfrage
    private func fetchScheduleFromAPI() async {
        do {
            // Lieder laden und offset anpassen
            let songs = try await getScheduleFromAPI(offset: offset, limit: limit)
            songsArray = songs // neue Lieder der Liste bzw. Array hinzufügen
            offset += limit // Offset erhöhen, um die nächsten Lieder zu laden
        } catch let error as HTTPError {
            print(error.message)
        } catch {
            print(HTTPError.fetchFailed.message)
        }
    }
}

#Preview {
    MainTabView()
}
