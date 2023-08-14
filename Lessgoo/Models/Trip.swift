//
//  Trip.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/14/23.
//

import Foundation

struct Trip: Codable{
  
    let destinationList: [Destination]
    let duration: String
    let title: String
    let description: String
    let isPublic: Bool
    
}
