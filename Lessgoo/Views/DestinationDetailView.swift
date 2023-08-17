//
//  DestinationDetailView.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/11/23.
//

import SwiftUI

struct DestinationDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @StateObject var viewModel: DestinationViewViewModel
    
    init(destination: Destination) {
        let model = DestinationViewViewModel(destination: destination)
        _viewModel = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        ScrollView() {
            VStack(alignment: .leading) {
                Text(viewModel.destination.destinationName)
                    .font(.title.bold())
                RatingsView(rating: viewModel.avgRating)
                Text(viewModel.destination.location)
                FavoritesView(viewModel: viewModel)
//                viewModel.destination.image
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250, alignment: .center)
                    .clipped()
                    .allowsHitTesting(false)
                Text(viewModel.destination.destinationDescription)
                
                if let ownReview = viewModel.ownReview {
                    ReviewCellView(review: ownReview)
                }
                
                HStack {
                    Button {
                        viewModel.showReviews.toggle()
                    } label: {
                        Text("All Reviews")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    Button {
                        viewModel.editingReview.toggle()
                    } label: {
                        Text("\(viewModel.ownReview == nil ? "Write a" : "Edit My") Review")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $viewModel.editingReview) {
                        if let ownReview = viewModel.ownReview {
                            EditReviewView(review: ownReview)
                        } else {
                            EditReviewView(destinationId: viewModel.destination.id)
                        }
                    }
                }
               
                if viewModel.showReviews {
                    ReviewsView(reviews: viewModel.reviews)
                }
            }
            .padding()
        }
        .onAppear {
            Task {
                dataManager.fetchTrips()
                viewModel.trips = dataManager.trips
            }
            
            viewModel.userId = dataManager.currentUserEmail
            
            let ref = dataManager.db.collection("Review").whereField("destinationId", isEqualTo: viewModel.destination.id)
            
            ref.addSnapshotListener { snapshot, error in
                guard let snapshot,
                      error == nil
                else {
                    print("---Get Reviews for Destination Error---")
                    print(error?.localizedDescription ?? "no snapshot")
                    return
                }
                
                viewModel.reviews = snapshot.documents.map {
                    let data = $0.data()
                    return Review(id: $0.documentID,
                                  authorId: data["authorId"] as? String ?? "",
                                  destinationId: data["destinationId"] as? String ?? "",
                                  rating: data["rating"] as? Double ?? 0.0,
                                  title: data["title"] as? String ?? "",
                                  reviewDescription: data["reviewDescription"] as? String ?? "",
                                  timestamp: dataManager.convertTimestampToTimeInterval(timestampString: data["timestamp"] as? String ?? "")
                    )
                }
            }
        }
    }
}

struct FavoritesView: View {
    @ObservedObject var viewModel: DestinationViewViewModel
    
    var body: some View {
        HStack {
            Button {
                viewModel.favorited.toggle()
            } label: {
                Image(systemName: viewModel.favorited ? "heart.fill": "heart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
                    .foregroundColor(.red)
            }
            Picker("Add to Trip", selection: $viewModel.selectedTripIndex) {
                Text("Add to Trip")
                    .tag(-1)
                ForEach(viewModel.trips.indices, id: \.self) { i in
                    HStack {
                        if viewModel.trips[i].destinations.contains(viewModel.destination.id) {
                            Image(systemName: "checkmark.square")
                        }
                        Text(viewModel.trips[i].title)
                    }
                    .tag(i)
                }
            }
            
        }
    }
}

//struct DDVPreview: PreviewProvider {
//    static let placeholderDest = Destination(
//        id: UUID().uuidString,
//        destinationName: "Ronda",
//        destinationOwner: "",
//        destinationDescription: "Ronda (Spanish pronunciation: [ˈronda]) is a town in the Spanish province of Málaga. It is located about 105 km (65 mi) west of the city of Málaga, within the autonomous community of Andalusia. Its population is about 35,000. Ronda is known for its cliffside location and a deep canyon that carries the Guadalevín River and divides the town. It is one of the towns and villages that are included in the Sierra de las Nieves National Park.",
//        image: "Ronda_2",
//        reviews: [],
//        ageRecomended: "-1",
//        location: "29400, Málaga, Spain",
//        tags: []
//    )
//
//    static var previews: some View {
//        DestinationDetailView(destination: placeholderDest)
//    }
//}
