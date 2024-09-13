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
        }
    }
}

//MARK: - ChartListView
struct ChartListView: View {
    @State var songsArray: [ChartEntry] = [] // Array der geladene Songs speichert
    @State var selectedType = "Songs" // Songs oder Alben auswählen
    @State var selectedCountry = "de" // Standard DE
    
    @Environment(\.openURL) var openURL // öffnet Apple Music
    
    let loadSongs = 50
    let chartTypes = ["Songs", "Alben"] // Picker für jeweiligen Typ
    let availableCountries = [ // Dictionary für Pickerauswahl Länder ["de": "Deutschland"] "de" <- Key, "Deutschland" <- Value
        "dz": "Algerien", "ao": "Angola", "ai": "Anguilla", "ag": "Antigua und Barbuda", "ar": "Argentinien", "am": "Armenien", "au": "Australien", "at": "Österreich", "az": "Aserbaidschan", "bs": "Bahamas", "bh": "Bahrain", "bb": "Barbados", "by": "Weißrussland", "be": "Belgien", "bz": "Belize", "bj": "Benin", "bm": "Bermuda", "bt": "Bhutan", "bo": "Bolivien", "ba": "Bosnien und Herzegowina", "bw": "Botsuana", "br": "Brasilien", "vg": "Britische Jungferninseln", "bg": "Bulgarien", "kh": "Kambodscha", "cm": "Kamerun", "ca": "Kanada", "cv": "Kap Verde", "ky": "Kaimaninseln", "td": "Tschad", "cl": "Chile", "cn": "China Festland", "co": "Kolumbien", "cr": "Costa Rica", "hr": "Kroatien", "cy": "Zypern", "cz": "Tschechische Republik", "ci": "Elfenbeinküste", "cd": "Demokratische Republik Kongo", "dk": "Dänemark", "dm": "Dominica", "do": "Dominikanische Republik", "ec": "Ecuador", "eg": "Ägypten", "sv": "El Salvador", "ee": "Estland", "sz": "Eswatini", "fj": "Fidschi", "fi": "Finnland", "fr": "Frankreich", "ga": "Gabun", "gm": "Gambia", "ge": "Georgien", "de": "Deutschland", "gh": "Ghana", "gr": "Griechenland", "gd": "Grenada", "gt": "Guatemala", "gw": "Guinea-Bissau", "gy": "Guyana", "hn": "Honduras", "hk": "Hongkong", "hu": "Ungarn", "is": "Island", "in": "Indien", "id": "Indonesien", "iq": "Irak", "ie": "Irland", "il": "Israel", "it": "Italien", "jm": "Jamaika", "jp": "Japan", "jo": "Jordanien", "kz": "Kasachstan", "ke": "Kenia", "kr": "Südkorea", "xk": "Kosovo", "kw": "Kuwait", "kg": "Kirgisistan", "la": "Laos", "lv": "Lettland", "lb": "Libanon", "lr": "Liberia", "ly": "Libyen", "lt": "Litauen", "lu": "Luxemburg", "mo": "Macao", "mg": "Madagaskar", "mw": "Malawi", "my": "Malaysia", "mv": "Malediven", "ml": "Mali", "mt": "Malta", "mr": "Mauretanien", "mu": "Mauritius", "mx": "Mexiko", "fm": "Mikronesien", "md": "Moldawien", "mn": "Mongolei", "me": "Montenegro", "ms": "Montserrat", "ma": "Marokko", "mz": "Mosambik", "mm": "Myanmar", "na": "Namibia", "np": "Nepal", "nl": "Niederlande", "nz": "Neuseeland", "ni": "Nicaragua", "ne": "Niger", "ng": "Nigeria", "mk": "Nordmazedonien", "no": "Norwegen", "om": "Oman", "pa": "Panama", "pg": "Papua-Neuguinea", "py": "Paraguay", "pe": "Peru", "ph": "Philippinen", "pl": "Polen", "pt": "Portugal", "qa": "Katar", "cg": "Republik Kongo", "ro": "Rumänien", "ru": "Russland", "rw": "Ruanda", "sa": "Saudi-Arabien", "sn": "Senegal", "rs": "Serbien", "sc": "Seychellen", "sl": "Sierra Leone", "sg": "Singapur", "sk": "Slowakei", "si": "Slowenien", "sb": "Salomonen", "za": "Südafrika", "es": "Spanien", "lk": "Sri Lanka", "kn": "St. Kitts und Nevis", "lc": "St. Lucia", "vc": "St. Vincent und die Grenadinen", "sr": "Suriname", "se": "Schweden", "ch": "Schweiz", "tw": "Taiwan", "tj": "Tadschikistan", "tz": "Tansania", "th": "Thailand", "to": "Tonga", "tt": "Trinidad und Tobago", "tn": "Tunesien", "tm": "Turkmenistan", "tc": "Turks- und Caicosinseln", "tr": "Türkei", "ae": "Vereinigte Arabische Emirate", "ug": "Uganda", "ua": "Ukraine", "gb": "Vereinigtes Königreich", "us": "Vereinigte Staaten", "uy": "Uruguay", "uz": "Usbekistan", "vu": "Vanuatu", "ve": "Venezuela", "vn": "Vietnam", "ye": "Jemen", "zm": "Sambia", "zw": "Simbabwe"]
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Menu {
                    ForEach(availableCountries.keys.sorted(), id: \.self) { key in
                        Button(action: {
                            selectedCountry = key
                            reloadData()
                        }) {
                            Label(availableCountries[key] ?? "", systemImage: selectedCountry == key ? "checkmark.circle.fill" : "circle")
                        }
                    }
                } label: {
                    HStack {
                        Text(availableCountries[selectedCountry] ?? "Land auswählen")
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
                
                Picker("Typ", selection: $selectedType) {
                    ForEach(chartTypes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                // Liste bei Auswahl neu laden
                .onChange(of: selectedType) {
                    reloadData()
                }
                .padding(.horizontal)
            }
            
            List {
                ForEach(Array(songsArray.enumerated()), id: \.element.id) { index, item in
                    //MARK: Albumcover Link
                    let url = URL(string: item.artworkUrl100)
                    
                    // Button damit ganze Listeneinträge tapbar sind und sich die URL öffnet
                    Button(action: {
                        // stellt sicher dass nur korrekte URL geöffnet werden um Crashes zu verhindern
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
                                /// Songtitel
                                Text("\(item.name)")
                                    .font(.headline)
                                
                                /// Name des Künstlers
                                Text("\(item.artistName)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    /// Releasedate
                                    Text(item.releaseDate)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            }
                            Spacer()
                            
                            /// Albumcover
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .frame(width: 95, height: 95)
                                    .cornerRadius(8)
                            } placeholder: {
                                //Image("placeholder") ohne placeholder viel flüssigeres Scrollverhalten
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
            // Lieder beim ersten Laden der Ansicht über API-Abfrage holen
            await fetchScheduleFromAPI()
        }
    }
    
    
    //MARK: - Funktion um Listeneinträge neu zu laden, wenn Pickerauswahl getätigt wurde
    private func reloadData() {
        // Liste leeren damit API neu lädt
        songsArray.removeAll()
        Task {
            await fetchScheduleFromAPI()
        }
    }
    
    //MARK: - Funkton zum Laden der lokalen JSON
    //    private func fetchSongsFromJSON() {
    //        guard let path = Bundle.main.path(forResource: "charts", ofType: "json") else {
    //            print("File doesn't exist")
    //            return
    //        }
    //        do {
    //            let data = try Data(contentsOf: URL(filePath: path))
    //            let songs = try JSONDecoder().decode(APIResults.self, from: data)
    //
    //            self.songsArray = songs.feed.results
    //        } catch {
    //            print("Error: \(error)")
    //            return
    //        }
    //    }
    
    //MARK: - Funktion zum Laden von Daten aus API
    private func getScheduleFromAPI() async throws -> [ChartEntry] {
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
    private func fetchScheduleFromAPI() async {
        do {
            // Lieder laden und offset anpassen
            let songs = try await getScheduleFromAPI()
            songsArray = songs // neue Lieder der Liste bzw. Array hinzufügen
        } catch  {
            print(HTTPError.fetchFailed.message, error)
        }
    }
}


#Preview {
    MainTabView()
}

