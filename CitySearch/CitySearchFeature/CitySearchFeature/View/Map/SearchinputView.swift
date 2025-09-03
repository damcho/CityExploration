//
//  SearchinputView.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation
import SwiftUI

struct SearchinputView: View {
    @ObservedObject var viewModel: CitySearchViewModel
    let onCitySelected: (City) -> Void
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            SearchBar(
                text: $viewModel.searchText,
                onTextChange: { viewModel.updateSearchText($0) },
                onClear: {
                    viewModel.clearSearch()
                }
            )
            
            SearchResultsView(
                viewModel: viewModel,
                onCitySelected: { city in
                    onCitySelected(city)
                }
            )
        }
        .padding()
    }
}

struct SearchBar: View {
    @Binding var text: String
    @FocusState var isSearchFieldFocused: Bool
    let onTextChange: (String) -> Void
    let onClear: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 12)
            
            TextField("Search for cities...", text: $text)
                .focused($isSearchFieldFocused)
                .textFieldStyle(.plain)
                .font(.body)
                .submitLabel(.search)
                .autocorrectionDisabled()
                .onChange(of: text) { _, newValue in
                    onTextChange(newValue)
                }
            
            if !text.isEmpty {
                Button(action: {
                    onClear()
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
    }
}

struct SearchResultsView: View {
    @ObservedObject var viewModel: CitySearchViewModel
    let onCitySelected: (City) -> Void
    
    var body: some View {
        switch viewModel.searchState {
        case .loading:
            LoadingView()
        case .error(let message):
            ErrorView(message: message)
        case .loaded(let cities):
            ResultsList(cities: cities, onCitySelected: onCitySelected)
        case .empty:
            EmptyView()
        }
    }
}

struct LoadingView: View {
    var body: some View {
        HStack {
            ProgressView()
                .scaleEffect(0.8)
            Text("Searching...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .searchResultCard()
    }
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.caption)
            .foregroundColor(.red)
            .searchResultCard()
    }
}

struct ResultsList: View {
    let cities: [City]
    let onCitySelected: (City) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                ForEach(cities, id: \.id) { city in
                    CityResultRow(city: city, onTap: {
                        onCitySelected(city)
                    })
                }
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: 300)
        .searchResultCard()
    }
}

extension View {
    func searchResultCard() -> some View {
        self
            .padding()
            .background(Color(.systemBackground).opacity(0.95))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    let store = try! PrefixTreeInMemoryCityStore(jsonString: SampleData.citiesJSON)
    let viewModel = CitySearchViewModel(cityStore: store, searchPolicy: MinimumCharacterSearchPolicy())
    
    SearchinputView(viewModel: viewModel) { city in
        print("City selected: \(city.name)")
    }
}
