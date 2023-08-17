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
    @State private var filteredDestinations: [Destination] = []
    @State private var selectedTags: Set<String> = []
    @State private var selectedSortOption: SortOption = .name
    
    private func performSearch(keyword: String){
        filteredDestinations = dataManager.destinations.filter{dest in
            dest.destinationName.contains(keyword)
        }
    }
    
    private func performSort(sortOption: SortOption){
       var sortedDestinations = destinations
        
        switch sortOption {
            case .name:
            sortedDestinations.sort { lhs, rhs in
                lhs.destinationName < rhs.destinationName
            }
        case .favorites:
            break
            
        case .rating:
            sortedDestinations.sort { lhs, rhs in
                lhs.averageRating < rhs.averageRating
            }
        }
        
        if filteredDestinations.isEmpty{
            dataManager.destinations = sortedDestinations
        }else{
            filteredDestinations = sortedDestinations
        }
        
    }
    
    private var destinations: [Destination] {
        if selectedTags.isEmpty {
            return filteredDestinations.isEmpty ? dataManager.destinations : filteredDestinations
        } else {
            let filteredByTags = dataManager.destinations.filter { destination in
                let destinationTagsSet = Set(destination.tags)
                return destinationTagsSet.isSuperset(of: selectedTags)
            }
            return filteredDestinations.isEmpty ? filteredByTags : filteredDestinations
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
               
                SearchBar(text: $searchText)
                
                Spacer()
                
                TagFilterView(tags: Array(dataManager.allTags), selectedTags: $selectedTags)
                
                Spacer()
                
                SortOptionsView(selectedSortOption: $selectedSortOption)
                
                Spacer()
                
                
                if dataManager.destinations.isEmpty {
                    Text("No Destinations found")
                    Text("Please update DB")
                } else {
                    List(destinations, id: \.id) { destination in
                        NavigationLink {
                            DestinationDetailView(destination: destination)
                                .environmentObject(dataManager)
                        } label: {
                            HomeViewListCellView(destination: destination)
                            .environmentObject(dataManager)
                        }
                    }//.searchable(text: $searchText)
                    .onChange(of: selectedSortOption, perform: performSort)
                    .onChange(of: searchText, perform: performSearch)
                    
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
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
            .padding(8)
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
