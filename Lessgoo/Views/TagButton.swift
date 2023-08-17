//
//  TagButton.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/16/23.
//
import SwiftUI

struct TagButton: View {
    var tag: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(tag)
                .font(.caption)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

