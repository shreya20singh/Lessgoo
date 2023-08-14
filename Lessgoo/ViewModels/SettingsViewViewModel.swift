//
//  SettingsViewViewModel.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/11/23.
//

import Foundation
import SwiftUI

class CurrencySettings: ObservableObject {
    @Published var currency = "USD $"
}


let CurrencyExchange = [ "USD $": 1.0, "GBP £":1.26, "CNY ¥":0.14]


struct StarsView: View {
    @Binding var rating: Int
    let highest = 5
    let unselected = Image(systemName: "star")
    let selected = Image(systemName: "star.fill")
    let font: Font = .largeTitle
    let fillColor: Color = .red
    let emptyColor: Color = .gray
    
    var body: some View {
        HStack{
            ForEach(1...highest,id:\.self) { number in
                    showStar(for: number)
                    .foregroundColor(number <= rating ? fillColor : emptyColor)
                    .onTapGesture {
                        rating = number
                        print(rating)
                    }
            }
            .font(font)
        }
    }
    
    func showStar(for number: Int) -> Image {
        if number > rating {
            return unselected
        } else {
            return selected
        }
    }
}
