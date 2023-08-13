//
//  ProfileView.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/11/23.
//

import SwiftUI

struct ProfileView: View {
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

//#Preview {
//    ProfileView()
//}
