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
    @State var selectedType = "Songs" // Songs oder Alben auswählen
    @State var selectedCountry = "de" // Standard DE
    
    let chartTypes = ["Songs", "Alben"] // Picker für jeweiligen Typ
    let availableCountries = [
        "af": "Afghanistan", "al": "Albanien", "dz": "Algerien", "ad": "Andorra", "ao": "Angola",
        "ag": "Antigua und Barbuda", "ar": "Argentinien", "am": "Armenien", "az": "Aserbaidschan",
        "bs": "Bahamas", "bh": "Bahrain", "bd": "Bangladesch", "bb": "Barbados", "be": "Belgien",
        "bz": "Belize", "bj": "Benin", "bt": "Bhutan", "bo": "Bolivien", "ba": "Bosnien und Herzegowina",
        "bw": "Botswana", "br": "Brasilien", "bn": "Brunei", "bg": "Bulgarien", "bf": "Burkina Faso",
        "bi": "Burundi", "cl": "Chile", "cn": "China", "ck": "Cookinseln",
        "cr": "Costa Rica", "de": "Deutschland", "dj": "Dschibuti", "dm": "Dominica",
        "do": "Dominikanische Republik", "ec": "Ecuador", "sv": "El Salvador", "eh": "Erschließung",
        "ee": "Estland", "fj": "Fidschi", "fi": "Finnland", "fr": "Frankreich", "ga": "Gabon",
        "gm": "Gambia", "ge": "Georgien", "gh": "Ghana", "gr": "Griechenland", "gd": "Grenada",
        "gp": "Guadeloupe", "gu": "Guam", "gt": "Guatemala", "gn": "Guinea", "gw": "Guinea-Bissau",
        "gy": "Guyana", "hn": "Honduras", "hk": "Hongkong", "in": "Indien", "id": "Indonesien",
        "iq": "Irak", "ie": "Irland", "is": "Island", "il": "Israel", "it": "Italien", "jm": "Jamaika",
        "jp": "Japan", "jo": "Jordanien", "kh": "Kambodscha", "cm": "Kamerun", "ca": "Kanada",
        "cv": "Kap Verde", "kz": "Kasachstan", "qa": "Katar", "ke": "Kenia", "kg": "Kirgisistan",
        "ki": "Kiribati", "co": "Kolumbien", "hr": "Kroatien", "cu": "Kuba", "kw": "Kuwait",
        "la": "Laos", "ls": "Lesotho", "lv": "Lettland", "lb": "Libanon", "lr": "Liberia",
        "ly": "Libyen", "li": "Liechtenstein", "lt": "Litauen", "lu": "Luxemburg", "mg": "Madagaskar",
        "mw": "Malawi", "my": "Malaysia", "mt": "Malta", "ma": "Marokko", "mr": "Mauretanien",
        "mu": "Mauritius", "mx": "Mexiko", "md": "Moldawien", "mc": "Monaco", "mn": "Mongolei",
        "me": "Montenegro", "mz": "Mozambik", "mm": "Myanmar", "na": "Namibia", "nr": "Nauru",
        "np": "Nepal", "nc": "Neukaledonien", "ne": "Niger", "ng": "Nigeria", "mk": "Nordmazedonien",
        "no": "Norwegen", "om": "Oman", "pk": "Pakistan", "ps": "Palästina", "pa": "Panama",
        "pg": "Papua-Neuguinea", "py": "Paraguay", "pe": "Peru", "ph": "Philippinen", "pl": "Polen",
        "pt": "Portugal", "rw": "Ruanda", "ro": "Rumänien", "sm": "San Marino", "st": "Sao Tome und Principe",
        "sa": "Saudi-Arabien", "se": "Schweden", "ch": "Schweiz", "sn": "Senegal", "rs": "Serbien",
        "sc": "Seychellen", "sl": "Sierra Leone", "sg": "Singapur", "sk": "Slowakei", "si": "Slowenien",
        "sb": "Solomon-Inseln", "so": "Somalia", "es": "Spanien", "lk": "Sri Lanka", "kn": "St. Kitts und Nevis",
        "lc": "St. Lucia", "vc": "St. Vincent und die Grenadinen", "za": "Südafrika", "ss": "Südsudan",
        "kr": "Südkorea", "sy": "Syrien", "tj": "Tadschikistan", "tz": "Tansania", "th": "Thailand",
        "tg": "Togo", "to": "Tonga", "tt": "Trinidad und Tobago", "tn": "Tunesien", "tr": "Türkei",
        "tm": "Turkmenistan", "ug": "Uganda", "ua": "Ukraine", "hu": "Ungarn", "uy": "Uruguay",
        "uz": "Usbekistan", "vu": "Vanuatu", "ve": "Venezuela", "ae": "Vereinigte Arabische Emirate",
        "us": "Vereinigte Staaten", "gb": "Vereinigtes Königreich", "vn": "Vietnam",
        "cf": "Zentralafrikanische Republik", "cy": "Zypern"
    ]
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Land", selection: $selectedCountry) {
                    ForEach(availableCountries.keys.sorted(), id: \.self) { key in
                        Text(availableCountries[key] ?? "")
                    }
                }
                .onChange(of: selectedCountry) {
                    reloadData()
                }
                
                Picker("Typ", selection: $selectedType) {
                    ForEach(chartTypes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
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
                    
                    /// Chartposition
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
                    //öffnet Titel in Apple Music
                    .onTapGesture {
                        UIApplication.shared.open(URL(string: "\(item.url)")!)
                    }
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
        // Liste leeren und Offset zurücksetzen damit API neu lädt
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
        let urlString = "https://rss.applemarketingtools.com/api/v2/\(selectedCountry)/music/most-played/50/\(type).json"
        
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
