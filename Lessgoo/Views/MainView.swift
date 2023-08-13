//
//  MainView.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/11/23.
//

import SwiftUI

struct MainView: View {
    @State var sampleText = "Sample pre-filled text"
    @StateObject var sampleVM = ValidationManager()

    var body: some View {
//        TitledTextField(title: "Trip name", text: $sampleText, validationManager: sampleVM)
//        TripPlanningView()
//        TripPlanningView()
//        DestinationSearchView()
//        ProfilePresentView()
        ProfileView()
    }
}

//#Preview {
//    MainView()
//}
