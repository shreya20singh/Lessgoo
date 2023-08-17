//
//  TripPlanningView.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/11/23.
//

import SwiftUI

struct TripPlanningView: View {
    @State private var showingSheet = false
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                if (dataManager.trips.isEmpty) {
                    Text("No trips found")
                    Text("Please create trips")
                }
                
                List {
                    ForEach(dataManager.trips, id: \.id) { trip in
                        NavigationLink(destination: TripPresentView(trip: trip).environmentObject(dataManager)) {
                            TripListCellView(trip: trip).environmentObject(dataManager)
                        }
                    }
                }
                .background(Color.clear)

            
                Spacer()
                
                Button("Create Trip", action: {
                    showingSheet.toggle()
                })
                .sheet(isPresented: $showingSheet, onDismiss: {
                    Task {
                        dataManager.fetchTrips()
                    }
                }, content: {
                    CreateTripView()
                        .environmentObject(dataManager)
                        .presentationDetents([.fraction(0.4)])
                })
                
                Spacer()
                
            }
            .navigationBarTitle("Plan", displayMode: .large)
        }
        .onAppear {
            Task {
                dataManager.fetchTrips()
            }
        }
    }
}

struct TripPlanningView_Preview: PreviewProvider {
    static var previews: some View {
        TripPlanningView()
    }
}
