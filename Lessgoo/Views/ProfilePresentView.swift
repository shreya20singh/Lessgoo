//
//  ProfilePresentView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/13/23.
//

import SwiftUI

struct ProfilePresentView: View {
    @EnvironmentObject var dataManager: DataManager
    var profile: Profile? {
        dataManager.currentUserProfile
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                if let profile = profile, let url = URL(string: profile.photoURL) {
                    AsyncImage(url: url, content: {
                        image in
                        image.resizable().scaledToFit()
                    }, placeholder: {
                        ProgressView()
                    })
                } else {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(profile?.fullName ?? "Full name")
                        .font(.title)
                    Text(profile?.joinDate ?? "Join date")
                        .font(.subheadline)
                }
            }
            Text(profile?.aboutYou ?? "About you")
            HStack {
                Text(profile?.location ?? "Location")
                Spacer()
            }
        }
    }
}

struct ProfilePresentView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePresentView()
            .environmentObject(DataManager())
    }
}
