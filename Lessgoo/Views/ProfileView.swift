//
//  ProfileView.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/11/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    var body: some View {
        NavigationView{
            ScrollView {
                VStack {
                    ProfilePresentView(profile: dataManager.currentUserProfile).environmentObject(dataManager)
                    Divider().background(Color.gray)
                    
                }
                .padding(10)
            }
        }
    }
}

