//
//  TripPlanningView.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/11/23.
//

import SwiftUI

struct TripPlanningView: View {
    @State private var showingSheet = false
    
    // Sample data for the list
    let trips = [
        ("Beach Trip", Image(systemName: "sun.max.fill")),
        ("Mountain Trip", Image(systemName: "mountain.fill")),
        ("City Tour", Image(systemName: "building.columns.fill"))
    ]

    // Sample empty list
    let emptyTrips:[(String, Image)] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Plan")
                NavigationLink(destination: {
                    CreateTripView()
                }, label: {
                    Text("Go to Create trip")
                })
                
                Spacer()
                
                // When list is empty, list will hide itself
                // TODO: Add a placeholder view when list is empty
                List(trips, id: \.0) { tripName, tripImage in
                   NavigationLink(destination: TripPresentView()) {
                       TripListCellView(tripName: tripName, tripImage: tripImage)
                   }
                }
                
                Spacer()
                
                Button("Show Modal", action: {
                    showingSheet.toggle()
                })
                .sheet(isPresented: $showingSheet, content: {
                    CreateTripView()
                        .presentationDetents([.fraction(0.4)])
                })
                
                Spacer()
                
            }
            .navigationBarTitle("Plan", displayMode: .large)
        }
    }
}

//#Preview {
//    TripPlanningView()
//}

struct TripPlanningView_Preview: PreviewProvider {
    static var previews: some View {
        TripPlanningView()
    }
}
