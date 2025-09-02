//
//  FavoritesManager.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation

struct CodableCity: Codable {
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
    let id: Int
    
    init(from city: City) {
        self.name = city.name
        self.country = city.country
        self.latitude = city.latitude
        self.longitude = city.longitude
        self.id = city.id
    }
    
    func toCity() -> City {
        return City(
            name: name,
            country: country,
            latitude: latitude,
            longitude: longitude,
            id: id
        )
    }
}

actor UserDefaultsFavoriteCityManager {
    private var favoritesCities: [City] = []
    private var isLoaded = false
    private var observers: [UUID: @Sendable ([City]) -> Void] = [:]
    
    private let userDefaults: UserDefaults
    private let favoritesKey = "FavoriteCities"
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    func addObserver(id: UUID, callback: @escaping @Sendable ([City]) -> Void) {
        observers[id] = callback
        loadFavourites()
        let currentFavorites = favoritesCities
        Task { @MainActor in
            callback(currentFavorites)
        }
    }
    
    func removeObserver(id: UUID) {
        observers.removeValue(forKey: id)
    }
    
    private func notifyObservers() {
        let currentFavorites = favoritesCities
        let currentObservers = Array(observers.values)
        Task { @MainActor in
            for observer in currentObservers {
                observer(currentFavorites)
            }
        }
    }
    
    private func loadFavourites() {
        if let data = userDefaults.data(forKey: favoritesKey) {
            do {
                let decoder = JSONDecoder()
                let codableCities = try decoder.decode([CodableCity].self, from: data)
                favoritesCities = codableCities.map { $0.toCity() }
            } catch {
                favoritesCities = []
            }
        }
    }
    
    private func saveFavorites() throws {
        let encoder = JSONEncoder()
        let codableCities = favoritesCities.map { CodableCity(from: $0) }
        let data = try encoder.encode(codableCities)
        userDefaults.set(data, forKey: favoritesKey)
        userDefaults.synchronize()
    }
    
    func isFavorite(_ city: City) async -> Bool {
        loadFavourites()
        return favoritesCities.contains(city)
    }
    
    func toggleFavorite(_ city: City) async throws {
        loadFavourites()
        if let index = favoritesCities.firstIndex(of: city) {
            favoritesCities.remove(at: index)
        } else {
            favoritesCities.append(city)
        }
        try saveFavorites()
        notifyObservers()
    }
    
    func addToFavorites(_ city: City) async throws {
        loadFavourites()
        if !favoritesCities.contains(city) {
            favoritesCities.append(city)
            try saveFavorites()
            notifyObservers()
        }
    }
    
    func removeFromFavorites(_ city: City) async throws {
        loadFavourites()
        if let index = favoritesCities.firstIndex(of: city) {
            favoritesCities.remove(at: index)
            try saveFavorites()
            notifyObservers()
        }
    }
    
    func getFavoriteCities() async -> [City] {
        loadFavourites()
        return favoritesCities
    }
}
