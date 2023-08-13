//
//  CreateTripView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/12/23.
//

import SwiftUI

struct CreateTripView: View {
    @State var sampleText = "Sample pre-filled text"
    @StateObject var sampleVM = ValidationManager()
    
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    Spacer()
                    Text("Create a Trip")
                        .font(.title)
                    Spacer()
                }
                TitledTextField(title: "Trip name", text: $sampleText, validationManager: sampleVM)
                HStack {
                    Spacer()
                    Button("Create Trip", action: {
                        // Some action
                    })
                }
            }
        }
        .navigationBarTitle("Create a Trip", displayMode: .inline)
    }
}

struct CreateTripView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTripView()
    }
}
