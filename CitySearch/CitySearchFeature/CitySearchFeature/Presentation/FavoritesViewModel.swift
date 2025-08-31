//
//  FavoritesViewModel.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoriteCities: [City] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let favoritesManager: UserDefaultsFavoriteCityManager
    private let observerId = UUID()
    
    init(favoritesManager: UserDefaultsFavoriteCityManager) {
        self.favoritesManager = favoritesManager
        setupFavoritesObserver()
        loadFavorites()
    }
    
    private func setupFavoritesObserver() {
        Task {
            await favoritesManager.addObserver(id: observerId) { @Sendable [weak self] favorites in
                Task { @MainActor in
                    self?.favoriteCities = favorites
                }
            }
        }
    }
    
    func loadFavorites() {
        isLoading = true
        errorMessage = nil
        
        Task {
            let favorites = await favoritesManager.getFavoriteCities()
            favoriteCities = favorites
            isLoading = false
        }
    }
    
    func toggleFavorite(for city: City) {
        Task {
            await favoritesManager.toggleFavorite(city)
        }
    }
    
    func isFavorite(_ city: City) async -> Bool {
        await favoritesManager.isFavorite(city)
    }
    
    func removeFavorite(_ city: City) {
        Task {
            await favoritesManager.removeFromFavorites(city)
        }
    }
}
