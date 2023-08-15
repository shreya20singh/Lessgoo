//
//  TripEditView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/12/23.
//

import SwiftUI

struct TripPresentView: View {
    @State var tripNameSub: String = ""
    var tripImage: Image = Image(systemName: "photo") // Using system icon as placeholder
    
    @State var trip: Trip?
    @EnvironmentObject var dataManager: DataManager
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 5) {
                tripImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 120)
                    .clipped()
                
                Spacer()
                
                HStack {
                    Text(trip?.title ?? "Default Trip")
                        .font(.title)
                        .foregroundColor(.primary)
                    Spacer()
                    if trip?.privacy == "true" {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.blue)
                        Text("Private")
                            .font(.body)
                            .foregroundColor(.blue)
                    } else {
                        Image(systemName: "lock.open.fill")
                            .foregroundColor(.green)
                        Text("Public")
                            .font(.body)
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
                
                Text(tripNameSub)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                ExpandableText("Description: \(trip?.description ?? "No Description")")                
                
                Text("Destinations: \(trip?.destinations.joined(separator: ", ") ?? "No Destinations")")
                    .font(.body)
                    .foregroundColor(.primary)
                
                Text("Duration: \(formattedDuration(trip?.duration))")
                    .font(.body)
                    .foregroundColor(.primary)
                
            }
            .padding(10)
        }
        .navigationBarItems(
            trailing: HStack {
                NavigationLink(destination: TripEditView(trip: trip)) {
                    Image(systemName: "square.and.arrow.up.fill")
                }
                
                NavigationLink(destination: TripEditView(trip: trip)) {
                    Image(systemName: "pencil")
                }
            }
        )
        .onAppear {
            self.tripNameSub = getSubTitle()
            if let tripId = trip?.id {
                dataManager.fetchTrip(byId: tripId) { fetchedTrip in
                    if let fetchedTrip = fetchedTrip {
                        self.trip = fetchedTrip
                    }
                }
            }
        }
    }
    
    func getSubTitle() -> String {
        return "By \(dataManager.currentUserEmail)"
    }

    func formattedDuration(_ duration: String?) -> String {
        guard let duration = duration, let days = Int(duration) else {
            return "No Duration"
        }
        return days == 1 ? "1 day" : "\(days) days"
    }

}

struct TripPresentView_Previews: PreviewProvider {
    static var previews: some View {
        TripPresentView()
    }
}
