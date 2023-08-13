//
//  TitledTextField.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/12/23.
//

import SwiftUI

struct TitledTextField: View {
    var title: String
    @Binding var text: String
    @ObservedObject var validationManager: ValidationManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            TextField("", text: $text, onEditingChanged: { _ in
                    self.validationManager.validateInput(self.text)
                })
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(validationManager.isInputValid ? Color.gray : Color.red, lineWidth: 1)
                )
            HStack {
                if !validationManager.isInputValid {
                    Text("Invalid Input")
                        .foregroundColor(.red)
                }
                Spacer()
                Text("\(text.count) characters")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

struct TitledTextField_Previews: PreviewProvider {
    @State static var sampleText = "Sample pre-filled text"
    @StateObject static var sampleVM = ValidationManager()
    static var previews: some View {
        TitledTextField(title: "Trip name", text: $sampleText, validationManager: sampleVM)
    }
}
