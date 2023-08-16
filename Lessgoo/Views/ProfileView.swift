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
        ScrollView {
            VStack {
                ProfilePresentView()
                Divider().background(Color.gray)
                ProfilePresentView()
            }
            .padding(10)
        }
    }
}

