//
//  ChartListView.swift
//  MusicPlayerApp
//
//  Created by Dustin Nuzzo on 10.09.24.
//

import SwiftUI

struct ChartListView: View {
    let chartItems = [
        ChartItem(position: 1, albumCover: "cover1", songTitle: "ENDLICH TUT ES WIEDER WEH", artist: "ELIF", streams: "8,198,872 streams"),
        ChartItem(position: 2, albumCover: "cover1", songTitle: "BOMBERJACKE", artist: "ELIF", streams: "7,801,301 streams"),
        ChartItem(position: 3, albumCover: "cover1", songTitle: "BEIFAHRERSITZ", artist: "ELIF", streams: "3,366,102 streams"),
        ChartItem(position: 4, albumCover: "cover1", songTitle: "ROSES", artist: "ELIF", streams: "1,928,751 streams"),
        ChartItem(position: 5, albumCover: "cover1", songTitle: "MEIN BABE", artist: "ELIF", streams: "999,863 streams")
    ]
    
    var body: some View {
        List(chartItems) { item in
            HStack {
                // Chartposition
                Text("#\(item.position)")
                    .font(.headline)
                    .foregroundColor(.purple)
                
                VStack(alignment: .leading) {
                    // Songtitel
                    Text(item.songTitle)
                        .font(.headline)
                    
                    // Name des Künstlers
                    Text(item.artist)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Streams
                    Text(item.streams)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Albumcover
                Image(item.albumCover)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            }
            .padding(.vertical, 8)
        }
        .listStyle(PlainListStyle())
    }
}


#Preview {
    ChartListView()
}
