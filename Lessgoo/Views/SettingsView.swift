//
//  SettingsView.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/11/23.
//

import SwiftUI

struct SettingsView: View {

    
    @State private var selection: String?
    @State private var feedback: String = ""
    @State private var rate: Int = 4
    @StateObject private var curSetting = CurrencySettings()
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Currency Setting").bold().offset(y:-40)
                List(Array(CurrencyExchange.keys), id: \.self, selection: $selection) { contact in
                    Text(contact)
                }.frame(width: 400, height: 150).offset(y:-50)
                
                Button("Select " + "\(selection ?? "USD $")") {
                    curSetting.currency = "\(selection ?? "USD $")"
//                    print(curSetting.currency)
                }.offset(y:-50)
                
                Text("Click to Rate:").bold().offset(y:-50)
                
                HStack {
                    StarsView(rating:$rate)
                }.offset(y: -30)
                
                VStack (alignment: .leading) {
                    Text("Feedback").bold()
                    
                    TextField("Thanks for sharing your feedback", text:$feedback, axis: .vertical).frame(width: 350,height: 200,alignment: .topLeading)
                        .overlay {
                            RoundedRectangle(cornerRadius:5)
                                .stroke(.gray.opacity(0.5),lineWidth: 2)
                        }
                    
                    Button{
                        submit()
                    } label: {
                        Text("Submit")
                            .frame(width: 300, height: 40,alignment: .trailing)
                    }
                }.offset(y:-10)
                
                Button {
                    exit(0)
                } label: {
                    Text("Log out")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.pink, .blue], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.black)
                }.offset(y:20)
                
                
                
            }.navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func submit() {
        dataManager.addFeedback(rating: rate, feedbacks: feedback)
    }
}
