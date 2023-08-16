//
//  Feedback.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/14/23.
//

import Foundation

struct Feedback: Codable, Equatable{
    let rating: String
    let feedbackDescription: String
    let timestamp: TimeInterval
}
