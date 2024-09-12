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
            AsyncImage(url: URL(string: coverUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 15)).shadow(radius: 10)
                    .frame(width: 200, height: 200)
                    .padding()
                
            } placeholder: {
                // leer weil flüssiger beim scrollen
            }
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(songName)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    Text(artistName)
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Text("Veröffentlichung am: \(releaseDate)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                .padding(.top, 16)
                .padding(.trailing, 48)
            }
        }
        .navigationTitle("Song Details")
    }
}

#Preview {
    SongDetailView(songName: "HIMMEL", artistName: "ELIF", coverUrl: "", releaseDate: "22.22.22", songUrl: "")
}
