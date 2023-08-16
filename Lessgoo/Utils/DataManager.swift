//
//  DataManager.swift
//  Lessgoo
//
//  Created by Michael Kwok on 8/14/23.
//

import SwiftUI
import Firebase
import FirebaseStorage

class DataManager: ObservableObject {
    @Published var users: [User] = []
    @Published var currentUserEmail = ""
    @Published var trips: [Trip] = []
    @Published var currentUserProfile: Profile? = nil
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
                    let profileDocumentId = data["profileDocumentId"] as? String ?? ""
                    
                    let user = User(id: id, email: email, location: location, name: name, password: password, profileDocumentId: profileDocumentId)
                    self.users.append(user)
                }
            }
        }
    }
    
    func preserveCurrentUserEmail(email: String) {
        self.currentUserEmail = email
    }
    
    func addUser(email: String, name: String, location: String, password: String) {
        
        let ref = db.collection("Users").document(email)
        ref.setData(["email": email, "id" : email, "location":location, "name":name, "passowrd":password]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func addUserWithProfile(email: String, name: String, location: String, password: String) {
        let profileRef = db.collection("Profile").document()
        profileRef.setData([
            "fullName": "",
            "location": location,
            "joinDate": Date().description,
            "photoURL": "",
            "aboutYou": "",
            "uploadedPhotoURLs": [String]()
        ]) { error in
            if let error = error {
                print("Error creating profile document: \(error)")
                return
            }

            let ref = self.db.collection("Users").document(email)
            ref.setData([
                "email": email,
                "id": email,
                "location": location,
                "name": name,
                "password": password,
                "profileDocumentId": profileRef.documentID
            ]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
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
    
    func createTrip(title: String, privacy: String, completion: @escaping (Error?) -> Void) {
        guard !currentUserEmail.isEmpty else {
            completion(NSError(domain: "DataManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user email set"]))
            return
        }
        
        let ref = db.collection("Trip")
        let id = UUID().uuidString
        let newTrip = [
            "id": id,
            "collaborators": [currentUserEmail],
            "title": title,
            "description": "Default Description",
            "destinations": [String](),
            "duration": "0",
            "privacy": privacy
        ] as [String : Any]
        
        ref.document(id).setData(newTrip) { error in
            completion(error)
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document successfully added")
            }
        }
    }
    
    func deleteTrip(tripId: String, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("Trip").document(tripId)
        ref.delete() { error in
            completion(error)
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                self.trips.removeAll(where: { $0.id == tripId })
                print("Document successfully removed!")
            }
        }
    }
    
    func addCollaborator(email: String, toTrip tripId: String, completion: @escaping (Error?) -> Void) {
        print("addCollaborator addCollaborator tripId \(tripId)")
        let ref = db.collection("Trip").document(tripId)
        
        print("addCollaborator addCollaborator tripId \(tripId)")

        ref.getDocument { (snapshot, error) in
            if let error = error {
                print("Error retrieving document: \(error)")
                completion(error)
                return
            }

            guard let snapshot = snapshot, let data = snapshot.data() else {
                print("Document not found or unable to retrieve data.")
                completion(NSError(domain: "DataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Document not found or unable to retrieve data."]))
                return
            }

            var collaborators = data["collaborators"] as? [String] ?? []
            if !collaborators.contains(email) {
                collaborators.append(email)

                ref.updateData(["collaborators": collaborators]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                        completion(error)
                    } else {
                        print("Document successfully updated with new collaborator")
                        completion(nil)
                    }
                }
            } else {
                print("Collaborator already exists")
                completion(nil)
            }
        }
    }
    
    func fetchProfile() {
        guard !currentUserEmail.isEmpty else {
            print("No current user email set")
            return
        }

        let userRef = db.collection("Users").document(currentUserEmail)

        userRef.getDocument { userSnapshot, userError in
            guard userError == nil, let userSnapshot = userSnapshot, let userData = userSnapshot.data() else {
                print(userError?.localizedDescription ?? "Unknown error")
                return
            }

            let profileDocumentId = userData["profileDocumentId"] as? String ?? ""
            let profileRef = self.db.collection("Profile").document(profileDocumentId)

            profileRef.getDocument { profileSnapshot, profileError in
                guard profileError == nil, let profileSnapshot = profileSnapshot, let profileData = profileSnapshot.data() else {
                    print(profileError?.localizedDescription ?? "Unknown error")
                    return
                }

                let profile = Profile(
                    id: profileSnapshot.documentID,
                    fullName: profileData["fullName"] as? String ?? "",
                    location: profileData["location"] as? String ?? "",
                    joinDate: profileData["joinDate"] as? String ?? "",
                    photoURL: profileData["photoURL"] as? String ?? "",
                    aboutYou: profileData["aboutYou"] as? String ?? "",
                    uploadedPhotoURLs: profileData["uploadedPhotoURLs"] as? [String] ?? []
                )

                self.currentUserProfile = profile
            }
        }
    }
    
    func saveProfile(fullName: String, aboutYou: String, location: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !currentUserEmail.isEmpty else {
            print("No current user email set")
            completion(.failure(NSError(domain: "Error", code: -1, userInfo: ["description": "No current user email set"])))
            return
        }
        
        let userRef = db.collection("Users").document(currentUserEmail)
        
        userRef.getDocument { userSnapshot, userError in
            guard userError == nil, let userSnapshot = userSnapshot, let userData = userSnapshot.data() else {
                print(userError?.localizedDescription ?? "Unknown error")
                completion(.failure(userError ?? NSError(domain: "Error", code: -1, userInfo: ["description": "Unknown error"])))
                return
            }
            
            let profileDocumentId = userData["profileDocumentId"] as? String ?? ""
            let profileRef = self.db.collection("Profile").document(profileDocumentId)
            
            let updatedProfileData: [String: Any] = [
                "fullName": fullName,
                "aboutYou": aboutYou,
                "location": location
            ]
            
            profileRef.setData(updatedProfileData, merge: true) { error in
                if let error = error {
                    print("Error saving profile: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Profile saved successfully")
                    completion(.success(()))
                    
                    // Update the currentUserProfile property
                    var updatedProfile = self.currentUserProfile ?? Profile(id: profileDocumentId, fullName: "", location: "", joinDate: "", photoURL: "", aboutYou: "", uploadedPhotoURLs: [])
                    updatedProfile.fullName = fullName
                    updatedProfile.aboutYou = aboutYou
                    updatedProfile.location = location
                    self.currentUserProfile = updatedProfile
                }
            }
        }
    }
    
    func saveProfile(fullName: String, aboutYou: String, location: String, photoURL: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !currentUserEmail.isEmpty else {
            print("No current user email set")
            completion(.failure(NSError(domain: "Error", code: -1, userInfo: ["description": "No current user email set"])))
            return
        }
        
        let userRef = db.collection("Users").document(currentUserEmail)
        
        userRef.getDocument { userSnapshot, userError in
            guard userError == nil, let userSnapshot = userSnapshot, let userData = userSnapshot.data() else {
                print(userError?.localizedDescription ?? "Unknown error")
                completion(.failure(userError ?? NSError(domain: "Error", code: -1, userInfo: ["description": "Unknown error"])))
                return
            }
            
            let profileDocumentId = userData["profileDocumentId"] as? String ?? ""
            let profileRef = self.db.collection("Profile").document(profileDocumentId)
            
            let updatedProfileData: [String: Any] = [
                "fullName": fullName,
                "aboutYou": aboutYou,
                "location": location,
                "photoURL": photoURL
            ]
            
            profileRef.setData(updatedProfileData, merge: true) { error in
                if let error = error {
                    print("Error saving profile: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Profile saved successfully")
                    completion(.success(()))
                    
                    // Update the currentUserProfile property
                    var updatedProfile = self.currentUserProfile ?? Profile(id: profileDocumentId, fullName: "", location: "", joinDate: "", photoURL: "", aboutYou: "", uploadedPhotoURLs: [])
                    updatedProfile.fullName = fullName
                    updatedProfile.aboutYou = aboutYou
                    updatedProfile.location = location
                    updatedProfile.photoURL = photoURL
                    self.currentUserProfile = updatedProfile
                }
            }
        }
    }
    
    func uploadProfilePicture(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard currentUserEmail.count > 0, let data = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Failed to convert image to data", code: 0, userInfo: nil)))
            return
        }

        let storageRef = Storage.storage().reference()
        let profilePictureRef = storageRef.child("profilePictures/\(currentUserEmail).jpg")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        profilePictureRef.putData(data, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            profilePictureRef.downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let url = url else {
                    completion(.failure(NSError(domain: "Failed to retrieve download URL", code: 0, userInfo: nil)))
                    return
                }

                completion(.success(url.absoluteString))
            }
        }
    }

    func uploadProfilePictureAsync(_ image: UIImage) async throws -> String {
        guard currentUserEmail.count > 0, let data = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "Failed to convert image to data", code: 0, userInfo: nil)
        }

        let storageRef = Storage.storage().reference()
        let profilePictureRef = storageRef.child("profilePictures/\(currentUserEmail).jpg")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let _ = try await profilePictureRef.putDataAsync(data, metadata: metadata)

        let url = try await profilePictureRef.downloadURL()

        return url.absoluteString
    }
}
