//
//  CitySearchViewModel.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation

@MainActor
class CitySearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [City] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCity: City?
    @Published var showSearchResults = false
    
    let cityStore: CitySearchable
    private let searchPolicy: SearchPolicy
    private var searchTask: Task<Void, Never>?
    
    init(cityStore: CitySearchable, searchPolicy: SearchPolicy) {
        self.cityStore = cityStore
        self.searchPolicy = searchPolicy
    }
    
    deinit {
        searchTask?.cancel()
    }
    
    func updateSearchText(_ newText: String) {
        searchText = newText
        
        searchTask?.cancel()
        
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            
            if !Task.isCancelled {
                await performSearch(query: newText)
            }
        }
    }
    
    private func performSearch(query: String) async {
        guard searchPolicy.shouldExecuteSearch(for: query) else {
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
}
