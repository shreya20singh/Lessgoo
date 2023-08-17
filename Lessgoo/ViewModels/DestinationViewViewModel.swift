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
//            print("set index \(selectedTripIndex)")
            if trips.indices.contains(selectedTripIndex) {
                trips[selectedTripIndex].destinations.append(destination.id)
            }
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
    @Published var editingReview = false
    
    var trips: [Trip] = []
    var userId = ""
    
    init(destination: Destination) {
        self.destination = destination
    }
}
