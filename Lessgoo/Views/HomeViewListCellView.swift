//
//  HomeViewListCellView.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/16/23.
//

import Foundation
import SwiftUI

struct HomeViewListCellView: View {
    var destinationImage: Image = Image(systemName: "photo") // Using system icon as placeholder
    var destination: Destination?
    @EnvironmentObject var dataManager: DataManager
    @Binding var isTapped: Bool
    var isTappable: Bool = false
    
    var averageRating: Double {
        if let reviews = destination?.reviews, !reviews.isEmpty {
            let totalRating = reviews.reduce(0.0) { $0 + $1.rating }
            return totalRating / Double(reviews.count)
        } else {
            return 0.0
        }
    }
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Image("Ronda")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100) // Adjust to your needs
                    .clipped()
                Image(destination?.image ?? "")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100) // Adjust to your needs
                    .clipped()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(destination?.destinationName ?? "Default Name")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Average Rating: \(String(format: "%.1f", averageRating))") // Display average rating
                
                Text(destination?.location ?? "Location not specified")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    ForEach(destination?.tags ?? [], id: \.self) { tag in
                        TagView(tag: tag) // Create a TagView or use Text(tag) if needed
                    }
                }
            }
        }
        .padding(10)
        .background(isTapped ? Color.blue.opacity(0.2) : Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        .onTapGesture {
            if isTappable {
                isTapped.toggle()
            }
        }
    }
}

struct TagView: View {
    var tag: String
    
    var body: some View {
        Text(tag)
            .font(.caption)
            .padding(4)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(4)
    }
}
