//
//  FavoritesViewModel.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation

enum FavoritesState {
    case loading
    case error(String)
    case empty
    case loaded([City])
}

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var state: FavoritesState = .loading
    
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
                    self?.state = .loaded(favorites)
                }
            }
        }
    }
    
    func loadFavorites() {
        state = .loading
        
        Task {
            let favorites = await favoritesManager.getFavoriteCities()
            guard !favorites.isEmpty else {
                state = .empty
                return
            }
            state = .loaded(favorites)
        }
    }
    
    func toggleFavorite(for city: City) {
        Task {
            do {
                try await favoritesManager.toggleFavorite(city)
            } catch {
                state = .error("Failed to toggle favorite: \(error.localizedDescription)")
            }
        }
    }
    
    func isFavorite(_ city: City) async -> Bool {
        await favoritesManager.isFavorite(city)
    }
    
    func removeFavorite(_ city: City) {
        Task {
            do {
                try await favoritesManager.removeFromFavorites(city)
                loadFavorites()
            } catch {
                state = .error("Failed to toggle favorite: \(error.localizedDescription)")
            }
        }
    }
}
