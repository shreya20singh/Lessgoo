//
//  JoinDateText.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/16/23.
//

import SwiftUI

struct JoinDateText: View {
    var dateString: String

    var formattedDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .none

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }

    var body: some View {
        Text("Joined on \(formattedDate)")
    }
}
