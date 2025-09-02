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
            VStack {
                if viewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.2)
                        
                        Text("Loading favorites...")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(.orange)
                        
                        Text("Error Loading Favorites")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(errorMessage)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        
                        Button("Retry") {
                            viewModel.loadFavorites()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.favoriteCities.isEmpty {
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
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(viewModel.favoriteCities, id: \.id) { city in
                                FavoriteCityRow(city: city, onTap: {
                                    onCitySelected?(city)
                                }, viewModel: viewModel)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.loadFavorites()
            }
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
