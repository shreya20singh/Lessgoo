//
//  DataManager.swift
//  Lessgoo
//
//  Created by Michael Kwok on 8/14/23.
//

import SwiftUI
import Firebase

class DataManager: ObservableObject {
    @Published var users: [User] = []
    @Published var currentUserEmail = ""
    @Published var trips: [Trip] = []
    let db = Firestore.firestore()
    
    
    init() {
        fetchUsers()
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

}
