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
}
