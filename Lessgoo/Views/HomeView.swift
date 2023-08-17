//
//  HomeView.swift
//  Lessgoo
//
//  Created by Aerologix Aerologix on 8/11/23.
//

import SwiftUI
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @State private var searchText = ""
    @State private var selectedTags: Set<String> = []
    @State private var selectedSortOption: SortOption = .name
    
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                SearchBar(text: $searchText)
                
                Spacer()
                
                TagFilterView(tags: dataManager.tags, selectedTags: $selectedTags)
                
                Spacer()
                
                SortOptionsView(selectedSortOption: $selectedSortOption)
                
                Spacer()
                
                
                if dataManager.destinations.isEmpty {
                    Text("No Destinations found")
                    Text("Please update DB")
                } else {
                    List(dataManager.destinations, id: \.id) { destination in
                        NavigationLink {
                            DestinationDetailView(destination: destination)
                                .environmentObject(dataManager)
                        } label: {
                            HomeViewListCellView(destination: destination)
                                                        .environmentObject(dataManager)
                        }
                    }
                }
            }
            .navigationBarTitle("Destinations", displayMode: .large)
        }
        .onAppear {
            Task {
                dataManager.fetchDestinations()
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        TextField("Search...", text: $text)
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
                    
                    if !text.isEmpty {
                        Button(action: {
                            dataManager.fetchFilteredDestinations(
                                            searchText: text,
                                            selectedTags: dataManager.selectedTags,
                                            selectedSortOption: dataManager.selectedSortOption
                            )
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
            .padding(.horizontal, 10)
    }
}

struct TagFilterView: View {
    var tags: [String]
    @Binding var selectedTags: Set<String>
    
    var body: some View {
        HStack {
            ForEach(tags, id: \.self) { tag in
                TagButton(tag: tag, isSelected: selectedTags.contains(tag)) {
                    if selectedTags.contains(tag) {
                        selectedTags.remove(tag)
                    } else {
                        selectedTags.insert(tag)
                    }
                }
            }
        }
    }
}

struct SortOptionsView: View {
    @Binding var selectedSortOption: SortOption
    
    var body: some View {
        Picker("Sort by", selection: $selectedSortOption) {
            ForEach(SortOption.allCases) { option in
                Text(option.rawValue.capitalized)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

enum SortOption: String, CaseIterable, Identifiable {
    case name
    case favorites
    case rating
    
    var id: SortOption { self }
}
