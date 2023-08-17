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

struct ReviewsViewNew: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        LazyVStack {
            ForEach(dataManager.currentUserReviews) {
                ReviewCellViewNew(review: $0, showDestination: true)
                    .environmentObject(dataManager)
            }
        }
    }
}

struct ReviewCellViewNew: View {
    var review: Review
    var showDestination = false
    @State var destinationName = ""
    @State var isPresented = false
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(alignment: .leading) {
            if showDestination {
                // Show destination when used for user reviews
                Text(destinationName)
                    .font(.title2)
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
        .onAppear {
            Task {
                dataManager.getDestinationName(by: review.destinationId) { (destinationName) in
                    if let destinationName = destinationName {
                        self.destinationName = destinationName
                        print("The destination name is: \(destinationName)")
                    } else {
                        print("Failed to fetch destination name")
                    }
                }

            }
        }
        .sheet(isPresented: $isPresented) {
            EditReviewView(review: review)
        }
        .onTapGesture(perform: {
            isPresented.toggle()
        })
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.gray, lineWidth: 1)
        )
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
