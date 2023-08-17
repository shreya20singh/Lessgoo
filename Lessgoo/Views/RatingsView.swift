//
//  RatingsView.swift
//  Lessgoo
//
//  Created by Yang Yi on 8/14/23.
//

import SwiftUI

struct RatingsView: View {
    var rating: Double
    var showNumber = true
    
    func nameForStar(_ i: Int) -> String {
        if Double(i) <= rating {
            return "star.fill"
        } else if Double(i) - 0.5 <= rating {
            return "star.leadinghalf.filled"
        } else {
           return "star"
        }
    }
    
    var body: some View {
        HStack {
            if showNumber {
                Text("\(rating, specifier: "%.1f")")
            }
            HStack(spacing: 0) {
                ForEach(1...5, id: \.self) { i in
                    Image(systemName: nameForStar(i))
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}
