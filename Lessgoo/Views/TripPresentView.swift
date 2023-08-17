//
//  TripEditView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/12/23.
//

import SwiftUI

struct TripPresentView: View {
    @State var tripNameSub: String = ""
    @State private var showingSheet = false
    @State var trip: Trip
    var photoURL: String?
    
    @State private var isImagePickerDisplayed: Bool = false
    @State private var selectedImage: UIImage?
    
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
        
    @State private var showAlert = false
    @State private var isCellTapped = false
    var body: some View {
        ZStack {
            ScrollView{
                VStack(alignment: .leading, spacing: 5) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: 180)
                            .clipped()
                            .onTapGesture {
                                isImagePickerDisplayed.toggle()
                            }
                    } else if let photoURL, let url = URL(string: photoURL) {
                        AsyncImage(url: url, content: {
                            image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width, height: 180)
                                .clipped()
                                .onTapGesture {
                                    isImagePickerDisplayed.toggle()
                                }
                        }, placeholder: {
                            ProgressView()
                        })
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: 180)
                            .clipped()
                            .onTapGesture {
                                isImagePickerDisplayed.toggle()
                            }
                    }
                    
                    Spacer()
                    
                    HStack {
                        //                  
                        Text("Duration: \(formattedDuration(trip.duration))")
                            .font(.title)
                            .foregroundColor(.primary)
                        Spacer()
                        if trip.privacy == "true" {
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
                    .padding()
                    
                    Spacer()
                    
                    Text(tripNameSub)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .padding()
                    
                    Spacer()
                    
                    ExpandableText("\(trip.description ?? "No Description")")
                        .padding()
                    
                    ForEach(dataManager.currentTripDestinations) { destination in
                        HomeViewListCellView(destinationImage: Image(systemName: "photo"), destination: destination, isTapped: $isCellTapped)
                            .environmentObject(dataManager)
                            .padding()
                    }
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Are you sure you want to delete this trip?"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        deleteTrip()
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationBarTitle(trip.title ?? "Default Trip", displayMode: .large)
            .navigationBarItems(
                trailing: HStack {
                    CollaboratorsButton(trip: trip)
                    Button(action: {
                        showAlert.toggle()
                    }) {
                        Image(systemName: "trash")
                    }
                    
                    NavigationLink(destination: TripEditView(trip: $trip).environmentObject(dataManager)) {
                        Image(systemName: "pencil")
                    }
                }
            )
            .sheet(isPresented: $isImagePickerDisplayed, onDismiss: {
                if let image = selectedImage {
                    dataManager.uploadTripPicture(trip: trip, image) { result in
                        switch result {
                        case .success(let photoURL):
                            print("Uploaded profile picture. URL: \(photoURL)")
                            
                            dataManager.updateTripPhotoURL( tripId: trip.id, photoURL: photoURL) { error in
                                print(error?.localizedDescription)
                            }
                            trip.photoURL = photoURL

                        case .failure(let error):
                            print("Error uploading profile picture: \(error.localizedDescription)")
                            // Handle the error (e.g., show an alert)
                        }
                    }
                }
                dataManager.fetchTrips()
            }, content: {
                ImagePicker(selectedImage: $selectedImage, isImagePickerDisplayed: $isImagePickerDisplayed)
            })
            .onAppear {
                dataManager.fetchCurrentTripDestinations(trip: trip)
                self.tripNameSub = getSubTitle()
//                if let tripId = trip.id {
                    dataManager.fetchTrip(byId: trip.id) { fetchedTrip in
                        if let fetchedTrip = fetchedTrip {
                            self.trip = fetchedTrip
                        }
                    }
//                }
            }
            
            // Floating button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showingSheet.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    .sheet(isPresented: $showingSheet, onDismiss: {
                        Task {
                            dataManager.updateCurrentTripDestinations(trip: trip)
                            dataManager.fetchTrips()
                        }
                    }, content: {
                        DestinationSearchView(trip: trip)
                            .environmentObject(dataManager)
                    })
                    .padding()
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
    
    func deleteTrip() {
//        guard let tripId = trip.id else {
//            return
//        }

        dataManager.deleteTrip(tripId: trip.id) { error in
            if let error = error {
                print("Error deleting trip: \(error)")
            } else {
                print("Trip successfully deleted")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

}

//struct TripPresentView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripPresentView()
//    }
//}
