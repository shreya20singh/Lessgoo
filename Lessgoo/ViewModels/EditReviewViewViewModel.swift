//
//  EditReviewViewViewModel.swift
//  Lessgoo
//
//  Created by Yang Yi on 8/16/23.
//

import SwiftUI

class EditReviewViewViewModel: ObservableObject {
    @Published var titleText = ""
    @Published var descriptionText = ""
    @Published var rating = 0
    
    var originalReview: Review?
    var destinationId: String?
    
    
    init(destinationId: String) {
        self.destinationId = destinationId
        self.originalReview = nil
    }
    
    init(review: Review) {
        originalReview = review
        self.destinationId = nil
        titleText = review.title
        descriptionText = review.reviewDescription
        rating = Int(review.rating)
    }
}
