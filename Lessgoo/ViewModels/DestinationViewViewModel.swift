//
//  DestinationViewViewModel.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/11/23.
//

import SwiftUI

class DestinationViewViewModel: ObservableObject {
    @Published var destination: Destination
    @Published var favorited = false
    @Published var selectedTripIndex = -1
    {
        didSet {
            guard trips.indices.contains(selectedTripIndex) else {
                return
            }
            trips[selectedTripIndex].destinations.append(destination.id)
            let tripId = trips[selectedTripIndex].id
            dataManager?.addDestinationToTrip(tripId: tripId, destinationId: destination.id)
        }
    }
    @Published var reviews: [Review] = [] {
        didSet {
            avgRating = reviews.reduce(into: 0.0, { $0 += $1.rating }) / Double(reviews.count)
            for review in reviews {
                if review.authorId == userId {
                    ownReview = review
                    break
                }
            }
        }
    }
    @Published var avgRating = 0.0
    @Published var showReviews = false
    @Published var ownReview: Review? = nil
//    {
//        didSet {
//            print("ownReview Set")
//            print("title: \(ownReview?.title ?? "")")
//        }
//    }
    @Published var editingReview = false
    
    var dataManager: DataManager? = nil
    
    var trips: [Trip] = []
    var userId = ""
    
    init(destination: Destination) {
        self.destination = destination
    }
}
