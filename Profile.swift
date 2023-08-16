//
//  ProfileModel.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/16/23.
//

import Foundation

struct Profile: Identifiable {
    
    var id: String
    var fullName: String
    var location: String
    var joinDate: String
    var photoURL: String
    var aboutYou: String
    var uploadedPhotoURLs: [String]
}
