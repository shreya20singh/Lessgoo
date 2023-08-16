//
//  TripAddCollaboratorView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/15/23.
//

import SwiftUI

struct TripAddCollaboratorView: View {
    var trip: Trip
    
    @State private var collaboratorEmail = ""
    @StateObject var validationManager = ValidationManager()
    
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Text("Add Collaborator")
                        .font(.title)
                    Spacer()
                }
                
                TitledTextField(title: "Email", text: $collaboratorEmail, validationManager: validationManager)
                
                Button("Add Collaborator", action: {
                    // Validate the email here
//                    guard validationManager.isValidEmail(collaboratorEmail) else {
//                        print("Invalid email address")
//                        return
//                    }
                    
                    // Add the collaborator to the trip
                    dataManager.addCollaborator(email: collaboratorEmail, toTrip: trip.id) { error in
                        if let error = error {
                            print("Error adding collaborator: \(error)")
                        } else {
                            print("Collaborator successfully added")
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                })
                .padding()
            }
            .padding()
        }
        .navigationBarTitle("Add Collaborator", displayMode: .inline)
    }
}
