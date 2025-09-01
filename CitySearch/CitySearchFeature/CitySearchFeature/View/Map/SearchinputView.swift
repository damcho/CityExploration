//
//  SearchinputView.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import SwiftUI

struct SearchinputView: View {
    @ObservedObject var viewModel: CitySearchViewModel
    let onCitySelected: (City) -> Void
    @FocusState private var isSearchFieldFocused: Bool
    @State private var localSearchText: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 12)
                
                TextField("Search for cities...", text: $localSearchText)
                    .focused($isSearchFieldFocused)
                    .textFieldStyle(.plain)
                    .font(.body)
                    .submitLabel(.search)
                    .onChange(of: localSearchText) { _, newValue in
                        viewModel.updateSearchText(newValue)
                    }
                
                if !localSearchText.isEmpty {
                    Button(action: {
                        localSearchText = ""
                        viewModel.clearSearch()
                        isSearchFieldFocused = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 12)
                }
            }
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSearchFieldFocused ? Color.blue : Color.clear, lineWidth: 2)
            )
            
            if viewModel.showSearchResults {
                if viewModel.isLoading {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Searching...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemBackground).opacity(0.95))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color(.systemBackground).opacity(0.95))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                } else if !viewModel.searchResults.isEmpty {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                            ForEach(viewModel.searchResults, id: \.name) { city in
                                CityResultRow(city: city, onTap: {
                                    onCitySelected(city)
                                    localSearchText = ""
                                    isSearchFieldFocused = false
                                })
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: 300)
                    .background(Color(.systemBackground).opacity(0.95))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
        }
        .padding()
        .onAppear {
            localSearchText = viewModel.searchText
        }
        .onChange(of: viewModel.searchText) { _, newValue in
            if localSearchText != newValue {
                localSearchText = newValue
            }
        }
    }
}

#Preview {
    let store = try! InMemoryCityStore(jsonString: SampleData.citiesJSON)
    let viewModel = CitySearchViewModel(cityStore: store)
    
    return SearchinputView(viewModel: viewModel) { city in
        print("City selected: \(city.name)")
    }
}
