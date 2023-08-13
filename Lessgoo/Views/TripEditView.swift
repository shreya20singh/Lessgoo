//
//  TripEditView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/12/23.
//

import SwiftUI

struct TripEditView: View {
    var tripName: String = "Default Trip"
    var tripNameSub: String = "By Jialiang Xiao 0 Items"
    var tripImage: Image = Image(systemName: "photo") // Using system icon as placeholder
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 5) {
                tripImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 120)
                    .clipped()
                
                Spacer()
                
                Text(tripName)
                    .font(.title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(tripNameSub)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
            }
            .padding(10)
        }
    }
}

struct TripEditView_Previews: PreviewProvider {
    static var previews: some View {
        TripEditView()
    }
}
