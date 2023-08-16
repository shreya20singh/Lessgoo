//
//  LockToggleButton.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/15/23.
//

import SwiftUI

struct LockToggleButton: View {
    @Binding var isLocked: Bool
    
    var body: some View {
        Button(action: {
            isLocked.toggle()
        }) {
            HStack {
                Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                    .foregroundColor(isLocked ? .blue : .green)
                Text(isLocked ? "Private" : "Public")
                    .font(.body)
                    .foregroundColor(isLocked ? .blue : .green)
            }
        }
    }
}
