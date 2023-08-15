//
//  TripEditView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/12/23.
//

import SwiftUI

struct TripEditView: View {
    @State var sampleText = "Sample pre-filled text"
    @StateObject var sampleVM = ValidationManager()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    TitledTextField(title: "Trip Name", text: $sampleText, validationManager: sampleVM)
                    Spacer()
                    TitledTextField(title: "Trip Name", text: $sampleText, validationManager: sampleVM)
                    
                }
            }
        }
        .navigationTitle("Edit")
    }
}

struct TripEditView_Previews: PreviewProvider {
    static var previews: some View {
        TripEditView()
    }
}
