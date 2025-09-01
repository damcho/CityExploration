//
//  CityCardViewModel.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation

@MainActor
class CityCardViewModel: ObservableObject {
    @Published var selectedCity: City?
    @Published var isSelectedCityFavorite: Bool = false
    
    private let favoritesManager: UserDefaultsFavoriteCityManager
    private let observerId = UUID()
    
    init(favoritesManager: UserDefaultsFavoriteCityManager) {
        self.favoritesManager = favoritesManager
        setupFavoritesObserver()
    }
    
    private func setupFavoritesObserver() {
        Task {
            await favoritesManager.addObserver(id: observerId) { @Sendable [weak self] favorites in
                Task { @MainActor in
                    guard let self = self, let selectedCity = self.selectedCity else { return }
                    self.isSelectedCityFavorite = favorites.contains(selectedCity)
                }
            }
        }
    }
    
    func toggleFavorite(for city: City) {
        Task {
            try await favoritesManager.toggleFavorite(city)
        }
    }
    
    func isFavorite(_ city: City) async -> Bool {
        await favoritesManager.isFavorite(city)
    }
    
    func selectCity(_ city: City?) {
        selectedCity = city
        updateFavoriteStatus()
    }
    
    private func updateFavoriteStatus() {
        guard let selectedCity = selectedCity else {
            isSelectedCityFavorite = false
            return
        }
        
        Task {
            let isFavorite = await favoritesManager.isFavorite(selectedCity)
            isSelectedCityFavorite = isFavorite
        }
    }
}
