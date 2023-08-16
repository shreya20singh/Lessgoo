//
//  HomeViewListCellView.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/16/23.
//

import Foundation
import SwiftUI

struct HomeViewListCellView: View{
    var destinationImage: Image? // Using system icon as placeholder
    var destination: Destination?
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            destinationImage ?? Image(systemName: "photo")
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120) // Adjust to your needs
                .clipped() as! Image
            
            Text(destination?.destinationName ?? "Default Name")
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(.bottom, 5)
    }
}

#Preview {
    HomeViewListCellView(destinationImage: Image("Bistro"))
}
