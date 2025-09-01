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
    
    private let favoritesManager: UserDefaultsFavoriteCityManager
    private let observerId = UUID()
    
    init(favoritesManager: UserDefaultsFavoriteCityManager) {
        self.favoritesManager = favoritesManager
        setupFavoritesObserver()
    }
    
    private func setupFavoritesObserver() {
        Task {
            await favoritesManager.addObserver(id: observerId) { @Sendable [weak self] _ in
                Task { @MainActor in
                    self?.objectWillChange.send()
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
    }
}
