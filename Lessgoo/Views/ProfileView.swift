//
//  ProfileView.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/11/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var swipeCount = 0
    @State private var showDeleteButton = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ProfilePresentView(profile: dataManager.currentUserProfile).environmentObject(dataManager)
                    Divider().background(Color.gray)
                    Spacer()
                    if showDeleteButton {
                        DeleteAccountButton().environmentObject(dataManager)
                    }
                }
                .padding(10)
                .background(GeometryReader { geometry in
                    Color.clear.preference(key: ScrollViewOffsetKey.self, value: geometry.frame(in: .named("scrollView")).origin.y)
                })
            }
            .coordinateSpace(name: "scrollView")
            .onPreferenceChange(ScrollViewOffsetKey.self) { offset in
                if offset > 50 { // You can adjust this value to fit your needs
                    swipeCount += 1
                    if swipeCount >= 2 {
                        showDeleteButton = true
                    }
                }
            }
        }
    }
}

struct ScrollViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct DeleteAccountButton: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAlert = false
    
    var body: some View {
        Button(action: {
            showingAlert = true
        }) {
            Text("Delete Account")
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(Color.red)
                .cornerRadius(10)
                .padding(.top, 10)
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Deleting your account will permanently erase all your data."),
                primaryButton: .destructive(Text("Delete")) {
                    dataManager.deleteAccount { result in
                        switch result {
                        case .success:
                            print("Account deleted successfully")
                            // Handle successful account deletion (e.g., navigate back to the login view)
                        case .failure(let error):
                            print("Error deleting account: \(error.localizedDescription)")
                            // Handle the error (e.g., show an alert)
                        }
                    }
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
}

struct DeleteAccountButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountButton()
            .environmentObject(DataManager())
    }
}

