//
//  FavoritesViewModel.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation
import Combine

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoriteCities: [City] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let favoritesManager: UserDefaultsFavoriteCityManager
    private var cancellables = Set<AnyCancellable>()
    
    init(favoritesManager: UserDefaultsFavoriteCityManager) {
        self.favoritesManager = favoritesManager
        setupFavoritesSubscription()
        loadFavorites()
    }
    
    private func setupFavoritesSubscription() {
        favoritesManager.$favoritesCities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favorites in
                self?.favoriteCities = favorites
            }
            .store(in: &cancellables)
    }
    
    func loadFavorites() {
        isLoading = true
        errorMessage = nil
        
        favoriteCities = favoritesManager.getFavoriteCities()
        isLoading = false
    }
    
    func toggleFavorite(for city: City) {
        favoritesManager.toggleFavorite(city)
    }
    
    func isFavorite(_ city: City) -> Bool {
        favoritesManager.isFavorite(city)
    }
    
    func removeFavorite(_ city: City) {
        favoritesManager.removeFromFavorites(city)
    }
}
