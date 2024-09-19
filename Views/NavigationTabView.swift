//
//  NavigationTabView.swift
//  MusicPlayerApp
//
//  Created by Dustin Nuzzo on 19.09.24.
//

import SwiftUI

//MARK: - TabView
struct NavigationTabView: View {
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

#Preview {
    NavigationTabView()
}
