//
//  LoginView.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/11/23.
//


import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @StateObject private var userIsLoggedIn = LoginSettings()
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        if userIsLoggedIn.loggedIn {
//            SettingsView().environmentObject(dataManager)
            TripPlanningView().environmentObject(dataManager)
        } else {
            content
        }
    }
    
    var content: some View {
        
        
        NavigationView{
            ZStack {
                Color.black
                
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 1000, height: 400)
                    .rotationEffect(.degrees(135))
                    .offset(y: -350)
                
                VStack(spacing: 20) {
                    Text("Welcome")
                        .foregroundColor(.white)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .offset(x: -100, y: -100)
                    
                    TextField("Email", text: $email)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .placeholder(when: email.isEmpty) {
                            Text("Email")
                                .foregroundColor(.white)
                                .bold()
                        }
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.white)
                    
                    SecureField("Password", text: $password)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .placeholder(when: password.isEmpty) {
                            Text("Password")
                                .foregroundColor(.white)
                                .bold()
                        }
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.white)
                    
                    Button {
                        login()
                    } label: {
                        Text("Log in")
                            .bold()
                            .frame(width: 200, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
                            )
                            .foregroundColor(.white)
                    }
                    .padding(.top)
                    .offset(y: 100)
                    
                    
                    NavigationLink(destination: RegisterView().environmentObject(userIsLoggedIn).environmentObject(dataManager)){
                    Text("Do not have an account? Signup here")
                        .bold()
                        .foregroundColor(.white)
                    }
                    .padding(.top)
                    .offset(y: 110)
                    
                }
                .frame(width: 350)
            }
            .ignoresSafeArea()
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                userIsLoggedIn.loggedIn = true
                dataManager.preserveCurrentUserEmail(email: email)
            }
        }
    }
    
}



