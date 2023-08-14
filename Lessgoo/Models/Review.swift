//
//  Review.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/14/23.
//

import Foundation

struct Review: Codable, Equatable{
    let destination: Destination
    let rating: String
    let title: String
    let reviewDescription: String
    let timestamp: TimeInterval
    
    static func == (lhs: Review, rhs: Review) -> Bool {
        <#code#>
    }
}
