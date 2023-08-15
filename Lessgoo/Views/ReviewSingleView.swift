//
//  ReviewSingleView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/13/23.
//

import SwiftUI

struct ReviewSingleView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "pencil")
                
                VStack {
                    Text("destination")
                        .font(.title)
                    Text("timestamp")
                        .font(.subheadline)
                }
                
                // TODO: Delete and Edit button in HStack
            }
            
            // Rating
            
            Text("Review-Title")
            Text("Description")
        }
    }
}

struct ReviewSingleView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewSingleView()
    }
}
