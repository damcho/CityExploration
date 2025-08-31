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
                                CityResultRow(city: city) {
                                    viewModel.selectCity(city)
                                    isSearchFieldFocused = false
                                }
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
    }
}

struct CityResultRow: View {
    let city: City
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: "location.circle")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(city.name)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Text("Lat: \(String(format: "%.4f", city.latitude)), Lon: \(String(format: "%.4f", city.longitude))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
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
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let sampleCities = """
    [
        {
            "name": "Buenos Aires",
            "coord": {
                "lat": -34.6037,
                "lon": -58.3816
            }
        },
        {
            "name": "Barcelona",
            "coord": {
                "lat": 41.3851,
                "lon": 2.1734
            }
        },
        {
            "name": "Berlin",
            "coord": {
                "lat": 52.5200,
                "lon": 13.4050
            }
        },
        {
            "name": "Boston",
            "coord": {
                "lat": 42.3601,
                "lon": -71.0589
            }
        }
    ]
    """
    
    let store = try! InMemoryCityStore(jsonString: sampleCities)
    let viewModel = CitySearchViewModel(cityStore: store)
    
    return SearchinputView(viewModel: viewModel)
}
