//
//  ProfilePresentView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/13/23.
//

import SwiftUI

struct ProfilePresentView: View {
    @EnvironmentObject var dataManager: DataManager
    var profile: Profile?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                if let profile = profile, let url = URL(string: profile.photoURL) {
                    AsyncImage(url: url, content: {
                        image in
                        image
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
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
                    HStack {
                        Text(profile?.fullName ?? "Full name")
                            .font(.title)
                        Spacer()
                        NavigationLink(destination: ProfileEditView(profile: profile)) {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                    JoinDateText(dateString: profile?.joinDate ?? "Join date")
                }
            }
            ExpandableText(profile?.aboutYou ?? "About you")
            HStack {
                Text(profile?.location ?? "Location")
                Spacer()
            }
        }
        .onAppear {
            Task {
                dataManager.fetchProfile()
            }
        }
    }
}
