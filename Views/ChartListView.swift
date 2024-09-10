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
                ForEach(Array(songsArray.enumerated()), id: \.element) { index, item in
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
                                AsyncImage(url: URL(string: item.artworkUrl100))
                                    .frame(width: 95, height: 95)
                                    .cornerRadius(8)
                            }
                            .padding(.vertical, 8)
                        }
                        //öffnet Titel in Apple Music
                        .onTapGesture {
                            UIApplication.shared.open(URL(string: "\(item.url)")!)
                        }
                    }
                    .listRowBackground(Color(.systemGray).opacity(0.05)) // Hintergrund für die Listenzellen
                }
                .navigationTitle("Charts")
            }
            .listStyle(PlainListStyle())
            .background(Color(.systemGray).opacity(0.01)) // Hintergrund für die Liste
        }
        .task {
            fetchSongsFromJSON()
        }
    }
    
    //MARK: Funkton zum Laden der JSON
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
}

#Preview {
    MainTabView()
}
