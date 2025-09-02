//
//  FavoritesView.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel
    var onCitySelected: ((City) -> Void)?
    
    var body: some View {
        NavigationView {
            contentView
                .navigationTitle("Favorites")
                .navigationBarTitleDisplayMode(.large)
                .onAppear {
                    viewModel.loadFavorites()
                }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .loading:
            FavoritesLoadingView()
        case .error(let message):
            FavoritesErrorView(message: message) {
                viewModel.loadFavorites()
            }
        case .empty:
            FavoritesEmptyView()
        case .loaded(let cities):
            FavoritesListView(cities: cities, onCitySelected: onCitySelected, viewModel: viewModel)
        }
    }
}

// MARK: - State Views

private struct FavoritesLoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Loading favorites...")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct FavoritesErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Error Loading Favorites")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button("Retry", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct FavoritesEmptyView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Favorite Cities")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Search for cities and tap the heart icon to add them to your favorites.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct FavoritesListView: View {
    let cities: [City]
    let onCitySelected: ((City) -> Void)?
    let viewModel: FavoritesViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(cities, id: \.id) { city in
                    FavoriteCityRow(city: city, onTap: {
                        onCitySelected?(city)
                    }, viewModel: viewModel)
                }
            }
            .padding()
        }
    }
}

#Preview {
    let favoritesManager = UserDefaultsFavoriteCityManager()
    let viewModel = FavoritesViewModel(favoritesManager: favoritesManager)
    
    return FavoritesView(viewModel: viewModel) { city in
        print("Selected city: \(city.name)")
    }
}
