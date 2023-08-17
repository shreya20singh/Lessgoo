//
//  EditReviewView.swift
//  Lessgoo
//
//  Created by Yang Yi on 8/16/23.
//

import SwiftUI

struct EditReviewView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var viewModel: EditReviewViewViewModel
    
    //Editing existing review
    init(review: Review) {
        viewModel = EditReviewViewViewModel(review: review)
    }
    
    //Creating new review
    init(destinationId: String) {
        viewModel = EditReviewViewViewModel(destinationId: destinationId)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(viewModel.originalReview == nil ? "Add Review" : "Edit Review")
                .font(.title.bold())
            .frame(maxWidth: .infinity)
            ReviewStarsView(viewModel: viewModel)
            HStack {
                Text("Title")
                    .font(.title3)
                TextField("", text: $viewModel.titleText)
                    .textFieldStyle(.roundedBorder)
            }
            VStack(alignment: .leading) {
                Text("Description")
                    .font(.title3)
                TextEditor(text: $viewModel.descriptionText)
//                    .frame(maxHeight: 350)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.gray, lineWidth: 0.5)
                    )
                Button {
                    if let destinationId = viewModel.destinationId {
                        dataManager.submitReview(
                            destinationId: destinationId,
                            rating: Double(viewModel.rating),
                            title: viewModel.titleText,
                            description: viewModel.descriptionText
                        )
                    } else if let reviewId = viewModel.originalReview?.id {
                        dataManager.updateReview(
                            reviewId: reviewId,
                            rating: Double(viewModel.rating),
                            title: viewModel.titleText,
                            description: viewModel.descriptionText
                        )
                    }
                    
                    dismiss()
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .presentationDetents([.medium])
    }
}

struct ReviewStarsView: View {
    @ObservedObject var viewModel: EditReviewViewViewModel
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { i in
                Button {
                    viewModel.rating = i
                } label: {
                    Image(systemName: i <= viewModel.rating ? "star.fill" : "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 35)
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}

//struct EditReviewView_Preview: PreviewProvider {
//    static var previews: some View {
//        EditReviewView(destinationId: "")
//    }
//}
