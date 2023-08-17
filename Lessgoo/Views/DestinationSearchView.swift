//
//  DestinationSearchView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/12/23.
//

import SwiftUI

struct DestinationSearchView: View {
    @State private var searchText = ""
    @EnvironmentObject var dataManager: DataManager
    
    @State var trip: Trip?
    
    var filteredDestinations: [Destination] {
        dataManager.destinations.filter { destination in
            searchText.isEmpty || destination.destinationName.lowercased().contains(searchText.lowercased())
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search...", text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    self.searchText = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                
                List(sortedDestinations(), id: \.id) { destination in
                    let isTapped = Binding<Bool>(
                        get: {
                            dataManager.currentTripDestinations.contains(where: { $0.id == destination.id })
                        },
                        set: { newValue in
                            if newValue {
                                if !dataManager.currentTripDestinations.contains(where: { $0.id == destination.id }) {
                                    dataManager.currentTripDestinations.append(destination)
                                }
                            } else {
                                if let index = dataManager.currentTripDestinations.firstIndex(where: { $0.id == destination.id }) {
                                    dataManager.currentTripDestinations.remove(at: index)
                                }
                            }
                        }
                    )
                    
                    HomeViewListCellView(destinationImage: Image(systemName: "photo"), destination: destination, isTapped: isTapped, isTappable: true)
                        .environmentObject(dataManager)
                        .padding()
                }
            }
            .navigationBarTitle("Search")
        }
    }
    
    func sortedDestinations() -> [Destination] {
        return filteredDestinations.sorted { (dest1, dest2) -> Bool in
            if dataManager.currentTripDestinations.contains(where: { $0.id == dest1.id }) && !dataManager.currentTripDestinations.contains(where: { $0.id == dest2.id }) {
                return true
            } else if !dataManager.currentTripDestinations.contains(where: { $0.id == dest1.id }) && dataManager.currentTripDestinations.contains(where: { $0.id == dest2.id }) {
                return false
            } else {
                return dest1.destinationName < dest2.destinationName // You can change this line to your preferred sorting criteria
            }
        }
    }

}
