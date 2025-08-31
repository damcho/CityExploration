//
//  SearchinputView.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import SwiftUI

struct SearchinputView: View {
    @ObservedObject var viewModel: CitySearchViewModel
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 12)
                
                TextField("Search for cities...", text: $viewModel.searchText)
                    .focused($isSearchFieldFocused)
                    .textFieldStyle(.plain)
                    .font(.body)
                    .submitLabel(.search)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
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
            
            // Search Results
            if viewModel.isLoading {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Searching...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
            } else if !viewModel.searchResults.isEmpty {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.searchResults, id: \.name) { city in
                            CityResultRow(city: city)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 300)
            }
        }
        .padding()
    }
}

struct CityResultRow: View {
    let city: City
    
    var body: some View {
        HStack {
            Image(systemName: "location.circle")
                .foregroundColor(.blue)
                .font(.title2)
            
            Text(city.name)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    let sampleCities = """
    [
        {"name": "Buenos Aires"},
        {"name": "Barcelona"},
        {"name": "Berlin"},
        {"name": "Boston"}
    ]
    """
    
    let store = try! InMemoryCityStore(jsonString: sampleCities)
    let viewModel = CitySearchViewModel(cityStore: store)
    
    return SearchinputView(viewModel: viewModel)
}
