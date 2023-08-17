//
//  LessgooApp.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/11/23.
//

import SwiftUI
import FirebaseCore

@main
struct LessgooApp: App {
    
    @StateObject var dataManager = DataManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager) // Provide the dataManager to the environment
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        if dataManager.currentUserEmail.isEmpty {
            LoginView().environmentObject(dataManager)
        } else {
            BottomBarView().environmentObject(dataManager)
        }
    }
}
