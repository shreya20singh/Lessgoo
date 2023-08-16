//
//  TripListCellView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/12/23.
//

import SwiftUI

struct TripListCellView: View {
    var tripImage: Image = Image(systemName: "photo") // Using system icon as placeholder
    var trip: Trip?
    @EnvironmentObject var dataManager: DataManager
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            tripImage
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120) // Adjust to your needs
                .clipped()
            
            Text(trip?.title ?? "Default Trip")
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(.bottom, 5)
    }
}

//struct TripListCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripListCellView(tripName: "Beach Trip", tripImage: Image(systemName: "sun.max.fill")) // Using system icon as example
//            .previewLayout(.sizeThatFits)
//    }
//}
