//
//  CitySearchViewModel.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation
import Combine

@MainActor
class CitySearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [City] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCity: City?
    @Published var showSearchResults = false
    
    let cityStore: CitySearchable
    let favoritesManager: UserDefaultsFavoriteCityManager
    private var cancellables = Set<AnyCancellable>()
    
    init(cityStore: CitySearchable, favoritesManager: UserDefaultsFavoriteCityManager) {
        self.cityStore = cityStore
        self.favoritesManager = favoritesManager
        setupSearchSubscription()
        setupFavoritesSubscription()
    }
    
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchQuery in
                Task {
                    await self?.performSearch(query: searchQuery)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupFavoritesSubscription() {
        // Listen to favorites changes to trigger UI updates
        favoritesManager.$favoritesCities
            .sink { [weak self] _ in
                // This will trigger a UI update for any views observing this ViewModel
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            showSearchResults = false
            errorMessage = nil
            isLoading = false
            return
        }
        
        isLoading = true
        errorMessage = nil
        showSearchResults = true
        
        do {
            let results = try await cityStore.search(for: query)
            searchResults = results
            isLoading = false
            
            if results.isEmpty {
                errorMessage = "No cities found matching '\(query)'"
            }
        } catch {
            errorMessage = "Search failed: \(error.localizedDescription)"
            isLoading = false
            searchResults = []
        }
    }
    
    func selectCity(_ city: City) {
        selectedCity = city
        searchText = ""
        showSearchResults = false
        searchResults = []
        errorMessage = nil
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
        errorMessage = nil
        showSearchResults = false
        selectedCity = nil
    }
    
    func toggleFavorite(for city: City) {
        favoritesManager.toggleFavorite(city)
    }
    
    func isFavorite(_ city: City) -> Bool {
        favoritesManager.isFavorite(city)
    }
}
