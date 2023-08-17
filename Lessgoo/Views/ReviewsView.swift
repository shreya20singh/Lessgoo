//
//  ReviewsView.swift
//  Lessgoo
//
//  Created by Yang Yi on 8/14/23.
//

import SwiftUI

struct ReviewsView: View {
    var showDestinations = false
    var reviews: [Review]
    
//    init(showDestinations: Bool = false, reviews: [Review]) {
//        self.showDestinations = showDestinations
//        self.reviews = reviews
//        print("Reviews View init")
//        print(reviews)
//    }
    
    var body: some View {
        LazyVStack {
            ForEach(reviews) {
                ReviewCellView(review: $0)
            }
        }
    }
}

struct ReviewCellView: View {
    var review: Review
    var showDestination = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if showDestination {
                // Show destination when used for user reviews
            }
            HStack{
                Text(review.title)
                    .font(.title3.bold())
                Spacer()
            }
            RatingsView(rating: review.rating)
            Text(review.reviewDescription)
                .padding(.vertical, 1)
            Text(ISO8601DateFormatter().string(from: Date(timeIntervalSinceNow: review.timestamp)))
                .foregroundColor(.gray)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.gray, lineWidth: 1)
        )
    }
}

//struct ReviewsView_Previews: PreviewProvider {
//    static let previewReviews = [0, 0.5, 1, 2.5, 5].map { i in
//        Review(id: UUID().uuidString, authorId: String(i), destinationId: "", rating: i, title: "Review \(i)", reviewDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ", timestamp: Date().timeIntervalSince1970)
//    }
//
//    static var previews: some View {
//        ReviewsView(reviews: previewReviews)
//    }
//}
