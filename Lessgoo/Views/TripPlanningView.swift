//
//  TripPlanningView.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/11/23.
//

import SwiftUI

struct TripPlanningView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Plan")
                NavigationLink(destination: Text("First Tab Detail View")) {
                    Text("Go to Detail")
                }
            }
            .navigationBarTitle("Plan", displayMode: .large)
        }
    }
}

//#Preview {
//    TripPlanningView()
//}

struct TripPlanningView_Preview: PreviewProvider {
    static var previews: some View {
        TripPlanningView()
    }
}
