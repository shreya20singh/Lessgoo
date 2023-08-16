//
//  BottomBarView.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/16/23.
//

import SwiftUI

struct BottomBarView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            TripPlanningView()
                .tabItem {
                    Label("Trips", systemImage: "map")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}


#Preview {
    BottomBarView()
}
