//
//  Destination.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/14/23.
//

import Foundation

struct Destination: Codable, Identifiable{
    let id: String
    let destinationName: String
    let destinationOwner: String
    let destinationDescription: String
    let image: String
    let reviews: [Review]
    let ageRecomended: String
    let location: String
    let tags: [String]
}
