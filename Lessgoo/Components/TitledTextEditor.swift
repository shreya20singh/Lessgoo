//
//  TitledTextEditor.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/15/23.
//

import SwiftUI

struct TitledTextEditor: View {
    var title: String
    @Binding var text: String
    @ObservedObject var validationManager: ValidationManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            TextEditor(text: $text)
                .onChange(of: text, perform: { value in
                    self.validationManager.validateInput(value)
                })
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(validationManager.isInputValid ? Color.gray : Color.red, lineWidth: 1)
                )
                .frame(height: 150)
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

struct TitledTextEditor_Previews: PreviewProvider {
    @State static var sampleText = "Sample pre-filled text"
    @StateObject static var sampleVM = ValidationManager()
    static var previews: some View {
        TitledTextEditor(title: "Trip name", text: $sampleText, validationManager: sampleVM)
    }
}
