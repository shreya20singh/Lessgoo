//
//  SearchView.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/12/23.
//

import SwiftUI

// TODO: Add data source to be real destinations
struct DestinationSearchView: View {
    @State private var searchText = ""
    let allItems: [String] = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape"]

    var filteredItems: [String] {
        allItems.filter { item in
            searchText.isEmpty || item.lowercased().contains(searchText.lowercased())
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search...", text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    self.searchText = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                
                List(filteredItems, id: \.self) { item in
                    Text(item)
                }
            }
            .navigationBarTitle("Search")
        }
    }
}

struct DestinationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationSearchView()
    }
}

