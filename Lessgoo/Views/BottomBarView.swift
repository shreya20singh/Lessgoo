//
//  BottomBarView.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/16/23.
//

import SwiftUI

struct BottomBarView: View {
    @EnvironmentObject var dataManager: DataManager
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            TripPlanningView()
                .environmentObject(dataManager)
                .tabItem {
                    Label("Trips", systemImage: "map")
                }
            
            ProfileView()
                .environmentObject(dataManager)
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

