//
//  Destination.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/14/23.
//

import Foundation

struct Destination: Codable{
    let id: String
    let destinationName: String
    let destinationOwner: String
    let destionationDescription: String
    let image: String
    let destinationPrice: String
    let localLanguages: [String]
    let ageRecomended: String
}
