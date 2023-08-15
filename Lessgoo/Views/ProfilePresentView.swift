//
//  ProfilePresentView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/13/23.
//

import SwiftUI

struct ProfilePresentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: "pencil") // Profile photo image
                VStack(alignment: .leading, spacing: 5) {
                    Text("Full name")
                        .font(.title)
                    Text("join date")
                        .font(.subheadline)
                }
            }
            Text("About you")
            HStack {
                Text("location")
                Spacer()
            }
        }
    }
}

struct ProfilePresentView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePresentView()
    }
}
