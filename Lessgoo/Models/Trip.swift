//
//  Trip.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/14/23.
//

import Foundation

struct Trip: Codable, Equatable{
  
    let destinationList: [Destination]
    let duration: String
    let title: String
    let description: String
    let isPublic: Bool
    
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        <#code#>
    }
    
}
