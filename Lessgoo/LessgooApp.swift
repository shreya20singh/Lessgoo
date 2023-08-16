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
    var body: some View {
        LoginView()
    }
}

