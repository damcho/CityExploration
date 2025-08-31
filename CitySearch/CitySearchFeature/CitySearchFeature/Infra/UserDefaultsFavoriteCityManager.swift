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
    
    init(from city: City) {
        self.name = city.name
        self.country = city.country
        self.latitude = city.latitude
        self.longitude = city.longitude
    }
    
    func toCity() -> City {
        return City(
            name: name,
            country: country,
            latitude: latitude,
            longitude: longitude
        )
    }
}

actor UserDefaultsFavoriteCityManager {
    static let shared = UserDefaultsFavoriteCityManager()
    
    private(set) var favoritesCities: [City] = []
    private var observers: [UUID: @Sendable ([City]) -> Void] = [:]
    
    private let userDefaults: UserDefaults
    private let favoritesKey = "FavoriteCities"
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    // Simple observer pattern instead of Combine
    func addObserver(id: UUID, callback: @escaping @Sendable ([City]) -> Void) {
        observers[id] = callback
        // Immediately call with current state
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
    
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: favoritesKey) {
            do {
                let decoder = JSONDecoder()
                let codableCities = try decoder.decode([CodableCity].self, from: data)
                favoritesCities = codableCities.map { $0.toCity() }
            } catch {
                print("Failed to decode favorites: \(error)")
                favoritesCities = []
            }
        }
    }
    
    private func saveFavorites() {
        do {
            let encoder = JSONEncoder()
            let codableCities = favoritesCities.map { CodableCity(from: $0) }
            let data = try encoder.encode(codableCities)
            userDefaults.set(data, forKey: favoritesKey)
        } catch {
            print("Failed to encode favorites: \(error)")
        }
    }
    
    func isFavorite(_ city: City) async -> Bool {
        return favoritesCities.contains(city)
    }
    
    func toggleFavorite(_ city: City) async {
        if let index = favoritesCities.firstIndex(of: city) {
            favoritesCities.remove(at: index)
        } else {
            favoritesCities.append(city)
        }
        saveFavorites()
        notifyObservers()
    }
    
    func addToFavorites(_ city: City) async {
        if !favoritesCities.contains(city) {
            favoritesCities.append(city)
            saveFavorites()
            notifyObservers()
        }
    }
    
    func removeFromFavorites(_ city: City) async {
        if let index = favoritesCities.firstIndex(of: city) {
            favoritesCities.remove(at: index)
            saveFavorites()
            notifyObservers()
        }
    }
    
    func getFavoriteCities() async -> [City] {
        return favoritesCities
    }
}
