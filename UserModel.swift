//
//  UserModel.swift
//  Lessgoo
//
//  Created by Michael Kwok on 8/14/23.
//

import Foundation

import SwiftUI

struct User: Identifiable {
    
    var id: String
    var email: String
    var location: String
    var name: String
    var password: String
}
