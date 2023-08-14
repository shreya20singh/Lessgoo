//
//  User.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/11/23.
//

import Foundation

struct User: Codable{
    let id: String
    let displayName: String
    let fullName: String
    let email: String
    let location: String
    let about: String
    let profilePicture: String
    let joiningDate: TimeInterval
}
