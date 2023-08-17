//
//  CollaboratorsButton.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/15/23.
//

import SwiftUI

struct CollaboratorsButton: View {
    @State var trip: Trip
    @State private var showAddCollaboratorView = false
    
    var body: some View {
        Button(action: {
            showAddCollaboratorView.toggle()
        }) {
            HStack {
                Image(systemName: "person.badge.plus")
                Text("\(trip.collaborators.count)")
                    .font(.headline)
            }
            .padding()
//            .background(Color.white)
//            .foregroundColor(Color.blue)
//            .cornerRadius(8)
        }
        .sheet(isPresented: $showAddCollaboratorView) {
            TripAddCollaboratorView(trip: $trip)
                .presentationDetents([.fraction(0.4)])
        }
    }
}

struct CollaboratorsButton_Previews: PreviewProvider {
    static var previews: some View {
        CollaboratorsButton(trip: Trip(id: "1234", collaborators: ["email1@example.com", "email2@example.com"], description: "A trip", destinations: ["Destination 1"], duration: "5 days", privacy: "public", title: "Trip Title"))
    }
}
