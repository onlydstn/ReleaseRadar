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
    
    @Environment(\.colorScheme) var appearence
    
    var body: some View {
        ScrollView {
            AsyncImage(url: URL(string: coverUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 15)).shadow(radius: 10)
                    .shadow(radius: 10)
                    .frame(width: 275, height: 275)
                    .padding()
                
            } placeholder: {
                // leer weil flüssiger beim scrollen
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
                
                Text("Veröffentlichung am: \(releaseDate)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                Spacer()
                
                Link(destination: URL(string: songUrl)!) {
                    HStack {
                        Image(appearence == .dark ? "darklogo" : "lightlogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading) {
                            Text("Listen on")
                                .bold()
                                .font(.system(size: 24))
                                Text(" Music")
                                .font(.system(size: 16))
                        }
                        .padding(.leading, 8)
                        Spacer()
                    }
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1)))
                    .padding()
                }
            }
        }
        .navigationTitle("Song Details")
    }
}

#Preview {
    SongDetailView(songName: "HIMMEL", artistName: "ELIF", coverUrl: "", releaseDate: "22.22.22", songUrl: "")
}
