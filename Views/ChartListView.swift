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
    @State var songsArray: [ChartEntry] = []
    
    
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
                }
                .navigationTitle("Charts")
            }
            .refreshable {
                //API refresh Funktion hier
            }
            .listStyle(PlainListStyle())
            .background(Color(.systemGray6).opacity(0.5))
        }
        .task {
            //fetchSongsFromJSON()
            await fetchScheduleFromAPI()
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
    private func getScheduleFromAPI() async throws -> [ChartEntry] {
        let urlString = "https://rss.applemarketingtools.com/api/v2/de/music/most-played/10/songs.json"
        
        guard let url = URL(string: urlString) else {
            throw HTTPError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(APIResults.self, from: data).feed.results
    }
    
    //MARK: - Funktion zum Aufruf der API Abfrage
    private func fetchScheduleFromAPI() async {
        do {
            songsArray = try await getScheduleFromAPI()
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
