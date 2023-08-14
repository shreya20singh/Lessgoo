//
//  Review.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/14/23.
//

import Foundation

struct Review: Codable{
    let destination: Destination
    let rating: String
    let title: String
    let reviewDescription: String
    let timestamp: TimeInterval
}
