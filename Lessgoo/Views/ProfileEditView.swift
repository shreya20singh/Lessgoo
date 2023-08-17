//
//  ProfileEditView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/16/23.
//

import SwiftUI

struct ProfileEditView: View {
    @State private var fullName: String = ""
    @State private var aboutYou: String = ""
    @State private var location: String = ""

    @State private var isImagePickerDisplayed: Bool = false
    @State private var selectedImage: UIImage?
    
    @StateObject var validationManager = ValidationManager()
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    var profile: Profile?

    init(profile: Profile?) {
        self.profile = profile
    }

    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center, spacing: 10) {

                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .onTapGesture {
                                    isImagePickerDisplayed.toggle()
                                }
                        } else if let profile = profile, let url = URL(string: profile.photoURL) {
                            AsyncImage(url: url, content: {
                                image in
                                image
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        isImagePickerDisplayed.toggle()
                                    }
                            }, placeholder: {
                                ProgressView()
                            })
                        } else {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .onTapGesture {
                                    isImagePickerDisplayed.toggle()
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            TitledTextField(title: "Full name", text: $fullName, validationManager: validationManager)
                        }
                    }
                    
                    TitledTextEditor(title:"About You", text: $aboutYou, validationManager: validationManager)
                    
                    HStack {
                        TitledTextField(title: "Location", text: $location, validationManager: validationManager)
                        Spacer()
                    }
                }
            }
        }
        .navigationBarItems(
            trailing:
                Button(action: {
                    if let image = selectedImage {
                        dataManager.uploadProfilePicture(image) { result in
                            switch result {
                            case .success(let photoURL):
                                print("Uploaded profile picture. URL: \(photoURL)")
                                
                                dataManager.saveProfile(fullName: fullName, aboutYou: aboutYou, location: location, photoURL: photoURL) { result in
                                    switch result {
                                    case .success:
                                        print("Profile saved successfully")
                                        // Optionally, you could navigate back to the ProfilePresentView
                                        presentationMode.wrappedValue.dismiss()
                                    case .failure(let error):
                                        print("Error saving profile: \(error.localizedDescription)")
                                        // Handle the error (e.g., show an alert)
                                    }
                                }

                            case .failure(let error):
                                print("Error uploading profile picture: \(error.localizedDescription)")
                                // Handle the error (e.g., show an alert)
                            }
                        }
                    } else {
                        dataManager.saveProfile(fullName: fullName, aboutYou: aboutYou, location: location) { result in
                            switch result {
                            case .success:
                                print("Profile saved successfully")
                                // Optionally, you could navigate back to the ProfilePresentView
                                presentationMode.wrappedValue.dismiss()
                            case .failure(let error):
                                print("Error saving profile: \(error.localizedDescription)")
                                // Handle the error (e.g., show an alert)
                            }
                        }
                    }
                }, label: {
                    Text("Save")
                })

        )
        .sheet(isPresented: $isImagePickerDisplayed, content: {
            ImagePicker(selectedImage: $selectedImage, isImagePickerDisplayed: $isImagePickerDisplayed)
        })
        .onAppear {
            if let profile = profile {
                fullName = profile.fullName
                aboutYou = profile.aboutYou
                location = profile.location
            }
        }
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView(profile: nil)
            .environmentObject(DataManager())
    }
}
