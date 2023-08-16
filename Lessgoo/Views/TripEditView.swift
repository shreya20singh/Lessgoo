//
//  TripEditView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/12/23.
//

import SwiftUI

struct TripEditView: View {
    var trip: Trip?
    
    @State var title = ""
    @State var description = ""
    @State var destinations = ""
    @State var duration = ""
    @State var privacy = ""
    @State var isPrivate = false
    @StateObject var validationManager = ValidationManager()
    
    init(trip: Trip?) {
        self.trip = trip
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    TitledTextField(title: "Trip Name", text: $title, validationManager: validationManager)
                    TitledTextEditor(title: "Description", text: $description, validationManager: validationManager)
                    TitledTextField(title: "Destinations", text: $destinations, validationManager: validationManager)
                    TitledTextField(title: "Duration(Days)", text: $duration, validationManager: validationManager)
                    Toggle(isOn: $isPrivate) {
                        Text("Privacy")
                    }
                    .onReceive([self.isPrivate].publisher.first()) { (value) in
                        self.privacy = value ? "true" : "false"
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Edit Trip")
        .navigationBarItems(trailing: Button("Save") {
            saveChanges()
        })
        .onAppear {
            loadTripData()
        }
    }
    
    func loadTripData() {
        self.title = trip?.title ?? "Default Trip"
        self.description = trip?.description ?? "Default Description"
        self.destinations = trip?.destinations.joined(separator: ", ") ?? "Default Destinations"
        self.duration = trip?.duration ?? "Default Durations"
        self.privacy = trip?.privacy ?? "Default Privacy"
        self.isPrivate = self.privacy == "true"
    }
    
    func saveChanges() {
        guard let tripId = trip?.id else {
            return
        }

        let updatedDestinations = destinations.components(separatedBy: ", ").filter { !$0.isEmpty }

        DataManager().updateTrip(tripId: tripId, title: title, description: description, destinations: updatedDestinations, duration: duration, privacy: privacy) { error in
            if let error = error {
                print("Error updating trip: \(error)")
            } else {
                print("Trip successfully updated")
            }
        }
    }
}

//struct TripEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleTrip = Trip(id: "1", collaborators: [], description: "Sample Description", destinations: ["Place1", "Place2"], duration: "1 day", privacy: "Private", title: "Sample Trip")
//        TripEditView(trip: sampleTrip)
//    }
//}
