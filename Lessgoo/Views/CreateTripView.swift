//
//  CreateTripView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/12/23.
//

import SwiftUI

struct CreateTripView: View {
    @State var sampleText = "Sample pre-filled text"
    
    @State private var title = ""
    @State private var privacy = false
    @StateObject var sampleVM = ValidationManager()
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    Spacer()
                    Text("Create a Trip")
                        .font(.title)
                    Spacer()
                }
                TitledTextField(title: "Trip name", text: $title, validationManager: sampleVM)
                
                HStack {
                    LockToggleButton(isLocked: $privacy)
                    Spacer()
                    Button("Create Trip", action: {
                        // Some action
                        dataManager.createTrip(
                            title: title,
                            privacy: privacy ? "true" : "false",
                            completion: { error in
                                if let error = error {
                                    print("Error creating trip: \(error)")
                                } else {
                                    print("Trip successfully created")
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        )
                        
                    })
                }
            }
            .padding()
        }
        .navigationBarTitle("Create a Trip", displayMode: .inline)
    }
}

struct CreateTripView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTripView()
    }
}
