//
//  TripModel.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/15/23.
//

import Foundation

struct Trip: Identifiable {
    
    var id: String
    var collaborators: [String]
    var description: String
    var destinations: [String]
    var duration: String
    var privacy: String
    var title: String
    var photoURL: String?
}
