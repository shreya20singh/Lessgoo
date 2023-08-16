//
//  DataManager.swift
//  Lessgoo
//
//  Created by Michael Kwok on 8/14/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class DataManager: ObservableObject {
    @Published var users: [User] = []
    @Published var currentUserEmail = ""
    @Published var trips: [Trip] = []
    @Published var destinations: [Destination] = []
    @Published var reviewsForDestination: [Review] = []
    @Published var tags: [String] = []
    @Published var selectedTags: Set<String> = []
    @Published var selectedSortOption: SortOption = .name
    
    
    let db = Firestore.firestore()
    
    
    init() {
        fetchUsers()
        fetchDestinations()
        // You can get all information you need here by calling certain queries.
    }
    func fetchUsers() {
        users.removeAll()
        
        let ref = db.collection("Users")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let location = data["location"] as? String ?? ""
                    let password = data["password"] as? String ?? ""
                    
                    let user = User(id: id, email: email, location: location, name: name, password: password)
                    self.users.append(user)
                }
            }
        }
    }
    
    func preserveCurrentUserEmail(email: String) {
        self.currentUserEmail = email
    }
    
    func addUser(email: String, name: String, location: String, passowrd: String) {
        
        let ref = db.collection("Users").document(email)
        ref.setData(["email": email, "id" : email, "location":location, "name":name, "passowrd":passowrd]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func addFeedback(rating: Int, feedbacks: String) {
        let id = UUID().uuidString
        let ref = db.collection("Feedback").document(id)
        ref.setData(["rating":rating,"description":feedbacks]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchTrips() {
        guard currentUserEmail.count > 0 else {
            return
        }
        
        let ref = db.collection("Trip").whereField("collaborators", arrayContains: currentUserEmail)
        
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                let trips = snapshot.documents.map { document -> Trip in
                    let data = document.data()
                    return Trip(
                        id: document.documentID,
                        collaborators: data["collaborators"] as? [String] ?? [],
                        description: data["description"] as? String ?? "",
                        destinations: data["destinations"] as? [String] ?? [],
                        duration: data["duration"] as? String ?? "",
                        privacy: data["privacy"] as? String ?? "",
                        title: data["title"] as? String ?? ""
                    )
                }
                self.trips = trips
            }
        }
    }
    
    func fetchTrip(byId id: String, completion: @escaping (Trip?) -> Void) {
        let ref = db.collection("Trip").document(id)
        
        ref.getDocument { snapshot, error in
            guard error == nil, let snapshot = snapshot else {
                print(error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            let data = snapshot.data()
            let trip = Trip(
                id: snapshot.documentID,
                collaborators: data?["collaborators"] as? [String] ?? [],
                description: data?["description"] as? String ?? "",
                destinations: data?["destinations"] as? [String] ?? [],
                duration: data?["duration"] as? String ?? "",
                privacy: data?["privacy"] as? String ?? "",
                title: data?["title"] as? String ?? ""
            )
            
            completion(trip)
        }
    }

    
    func updateTrip(tripId: String, title: String, description: String, destinations: [String], duration: String, privacy: String, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("Trip").document(tripId)
        ref.updateData([
            "title": title,
            "description": description,
            "destinations": destinations,
            "duration": duration,
            "privacy": privacy
        ]) { error in
            completion(error)
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func loadDatabase(fromCSV fileName: String) {
        // Fetch the path of the CSV file in your app bundle
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "csv") {
            do {
                let csvData = try String(contentsOfFile: filePath)
                
                // Split CSV data into lines
                let csvLines = csvData.components(separatedBy: "\n")
                
                for csvLine in csvLines {
                    let csvValues = csvLine.components(separatedBy: ",")
                    if csvValues.count >= 9 {
                        let id = csvValues[0]
                        let name = csvValues[1]
                        let description = csvValues[2]
                        let image = csvValues[3]
                        let localLanguages = csvValues[4]
                        let location = csvValues[5]
                        let owner = csvValues[6]
                        let ageRecomendation = csvValues[7]
                        let tags = csvValues[8]
                        
                        // Create a new document in the "destination" collection
                        let destinationRef = db.collection("Destination").document(id)
                        destinationRef.setData([
                            "id": id,
                            "name": name,
                            "description": description,
                            "image": image,
                            "localLanguages": localLanguages,
                            "location": location,
                            "owner": owner,
                            "ageReccomendation": ageRecomendation,
                            "tags": tags
                            // Add more fields as needed
                        ]) { error in
                            if let error = error {
                                print("Error adding document: \(error)")
                            } else {
                                print("Document added with ID: \(id)")
                            }
                        }
                    }
                }
            } catch {
                print("Error reading CSV file: \(error.localizedDescription)")
            }
        } else {
            print("CSV file not found")
        }
    }

    
    func convertTimestampToTimeInterval(timestampString: String) -> TimeInterval {
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            if let date = dateFormatter.date(from: timestampString) {
                return date.timeIntervalSince1970
            } else {
                return 0 // Return a default value or handle error as needed
            }
        }
    
    func fetchReviewForDestination(destinationID: String){
        reviewsForDestination.removeAll()
        let refReview = self.db.collection("Review")
        refReview.getDocuments { reviewSnapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshotReview = reviewSnapshot {
                for document in snapshotReview.documents {
                    let data = document.data()
                    let destinationId = data["destinationId"] as? String ?? ""
                    if(destinationId == destinationID){
                        let reviewid = data["id"] as? String ?? ""
                        let rating = data["rating"] as? String ?? ""
                        let reviewDescription = data["reviewDescription"] as? String ?? ""
                        let timestamp = data["timestamp"] as? String ?? ""
                        let title = data["title"] as? String ?? ""
                        let review = Review(id: reviewid,
                                            destinationId: destinationId,
                                            rating: rating,
                                            title: title,
                                            reviewDescription: reviewDescription,
                                            timestamp: self.convertTimestampToTimeInterval(timestampString: timestamp))
                        self.reviewsForDestination.append(review)
                    }
                }
            }
        }
    }
    
    func fetchDestinations() {
        destinations.removeAll()
        
        let ref = db.collection("Destination")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        let id = data["id"] as? String ?? ""
                        let destinationName = data["name"] as? String ?? ""
                        let destImage = data["image"] as? String ?? ""
                        let destinationOwner = data["owner"] as? String ?? ""
                        let destinationDescription = data["description"] as? String ?? ""
                        let ageRecomended = data["ageReccomendation"] as? String ?? ""
                        let location = data["location"] as? String ?? ""
                        let tags = (data["tags"] as? String ?? "").split(separator: ", ").map { String($0) }
                        self.fetchReviewForDestination(destinationID: id)
                        let destination = Destination(id: id,
                                                      destinationName: destinationName,
                                                      destinationOwner: destinationOwner,
                                                      destinationDescription: destinationDescription,
                                                      image: destImage,
                                                      reviews: self.reviewsForDestination,
                                                      ageRecomended: ageRecomended,
                                                      location: location,
                                                      tags: tags
                        )
                        self.destinations.append(destination)
                    }
                }
            
        }
    }
    
    func fetchFilteredDestinations(searchText: String, selectedTags: Set<String>, selectedSortOption: SortOption) {
        destinations.removeAll()
        var query = db.collection("Destination")
        
        if !searchText.isEmpty {
            query = query.whereField("destinationName", isGreaterThanOrEqualTo: searchText) as! CollectionReference
        }
        
        if !selectedTags.isEmpty {
            query = query.whereField("tags", arrayContainsAny: Array(selectedTags)) as! CollectionReference
        }
        
        switch selectedSortOption {
        case .name:
            query = query.order(by: "destinationName") as! CollectionReference
        case .favorites:
            // Implement sorting by number of favorites
            break
        case .rating:
            query = query.order(by: "averageRating", descending: true) as! CollectionReference
        }
        
        query.getDocuments { snapshot, error in
            guard error == nil, let snapshot = snapshot else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            var fetchedDestinations: [Destination] = []
            for document in snapshot.documents {
                let data = document.data()
                let id = data["id"] as? String ?? ""
                let destinationName = data["name"] as? String ?? ""
                let destImage = data["image"] as? String ?? ""
                let destinationOwner = data["owner"] as? String ?? ""
                let destinationDescription = data["description"] as? String ?? ""
                let ageRecomended = data["ageReccomendation"] as? String ?? ""
                let location = data["location"] as? String ?? ""
                let tags = (data["tags"] as? String ?? "").split(separator: ", ").map { String($0) }
                self.fetchReviewForDestination(destinationID: id)
                let destination = Destination(id: id,
                                              destinationName: destinationName,
                                              destinationOwner: destinationOwner,
                                              destinationDescription: destinationDescription,
                                              image: destImage,
                                              reviews: self.reviewsForDestination,
                                              ageRecomended: ageRecomended,
                                              location: location,
                                              tags: tags
                )
                self.destinations.append(destination)
            }
            
            self.destinations = fetchedDestinations
        }
    }

   

}
