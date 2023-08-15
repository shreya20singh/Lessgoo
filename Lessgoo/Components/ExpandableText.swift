//
//  ExpandableText.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/15/23.
//

import SwiftUI

struct ExpandableText: View {
    let text: String
    let collapsedMaxLines: Int
    
    @State private var expanded: Bool = false
    
    init(_ text: String, collapsedMaxLines: Int = 3) {
        self.text = text
        self.collapsedMaxLines = collapsedMaxLines
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(expanded ? nil : collapsedMaxLines)
                .onTapGesture {
                    withAnimation {
                        expanded.toggle()
                    }
                }
            
            if !expanded {
                Text("Expand")
                    .font(.body)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        withAnimation {
                            expanded.toggle()
                        }
                    }
            }
        }
    }
}

struct ExpandableText_Previews: PreviewProvider {
    static var previews: some View {
        ExpandableText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sit amet dui et erat eleifend volutpat a at tellus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae.")
    }
}
