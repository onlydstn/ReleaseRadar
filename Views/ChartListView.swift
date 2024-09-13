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
            
            ReleaseRadarView()
                .tabItem {
                    Image(systemName: "alarm.waves.left.and.right")
                    Text("Release Radar")
                }
        }
    }
}

//MARK: - ChartListView
struct ChartListView: View {
    @StateObject var viewModel = ChartListViewModel()
    @Environment(\.openURL) var openURL // opens Apple Music
    
    var body: some View {
        NavigationStack {
            VStack {
                Menu {
                    ForEach(CountryList.availableCountries.keys.sorted(), id: \.self) { key in
                        Button(action: {
                            viewModel.selectedCountry = key
                            viewModel.reloadData()
                        }) {
                            Label(CountryList.availableCountries[key] ?? "", systemImage: viewModel.selectedCountry == key ? "checkmark.circle.fill" : "circle")
                        }
                    }
                } label: {
                    HStack {
                        Text(CountryList.availableCountries[viewModel.selectedCountry] ?? "Land auswählen")
                            .foregroundColor(.primary)
                            .padding(.vertical, 10)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Picker("Typ", selection: $viewModel.selectedType) {
                    ForEach(viewModel.chartTypes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                // Liste bei Auswahl neu laden
                .onChange(of: viewModel.selectedType) {
                    viewModel.reloadData()
                }
                .padding(.horizontal)
            }
            
            List {
                ForEach(Array(viewModel.songsArray.enumerated()), id: \.element.id) { index, item in
                    //MARK: Albumcover Link
                    let url = URL(string: item.artworkUrl100)
                    
                    // Button so ListEntries are tappable and Apple Music opens
                    Button(action: {
                        // assures that obly valid URL are opened to prevent crashes
                        if let songURL = URL(string: item.url) {
                            openURL(songURL)
                        }
                    }) {
                        HStack {
                            Text("#\(index + 1)")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .foregroundStyle(.purple.opacity(0.3))
                                .padding(.trailing)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("\(item.name)")
                                    .font(.headline)
                                
                                Text("\(item.artistName)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Text(item.releaseDate)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            }
                            Spacer()
                            
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .frame(width: 95, height: 95)
                                    .cornerRadius(8)
                            } placeholder: {
                                //Image("placeholder") empty for smoother scrolling
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color(.clear))
                }
            }
            .navigationTitle("Charts")
            .listStyle(PlainListStyle())
            .background(Color(.systemGray6).opacity(0.5))
        }
        .task {
            // initial loading of songs by calling API
            await viewModel.fetchScheduleFromAPI()
        }
    }
}

#Preview {
    MainTabView()
}

