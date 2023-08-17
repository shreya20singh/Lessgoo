//
//  Review.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/14/23.
//

import Foundation

struct Review: Codable, Identifiable{
    let id: String
    let authorId: String
    let destinationId: String
    let rating: Double
    let title: String
    let reviewDescription: String
    let timestamp: TimeInterval
}
