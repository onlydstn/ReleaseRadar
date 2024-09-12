//
//  SongDetailView.swift
//  MusicPlayerApp
//
//  Created by Dustin Nuzzo on 12.09.24.
//

import SwiftUI

struct SongDetailView: View {
    let songName: String
    let artistName: String
    let coverUrl: String
    let releaseDate: String
    let songUrl: String
    
    @Environment(\.colorScheme) var appearance

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: coverUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 300)
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: UIScreen.main.bounds.width, height: 300)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(songName)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    Text(artistName)
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Text("Release Date: \(releaseDate)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    HStack {
                        Image(appearance == .dark ? "darklogo" : "lightlogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        VStack(alignment: .leading) {
                            Text("Listen on")
                                .bold()
                                .font(.caption)
                            Text(" Music")
                                .font(.footnote)
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    .onTapGesture {
                        // öffnet Apple Music
                        UIApplication.shared.open(URL(string: "\(songUrl)")!)
                    }
                }
                .padding(.top, 16)
            }
        }
        .navigationTitle("Song Details")
    }
}

#Preview {
    SongDetailView(songName: "HIMMEL", artistName: "ELIF", coverUrl: "", releaseDate: "22.22.22", songUrl: "")
}
