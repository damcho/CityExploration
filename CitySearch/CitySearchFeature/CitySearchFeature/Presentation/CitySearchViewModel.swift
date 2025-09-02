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
    var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCity: City?
    
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
        errorMessage = nil
        isLoading = false
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
                        
        guard searchPolicy.shouldExecuteSearch(for: trimmedQuery) else { return }
                
        do {
            isLoading = true
            let results = try await cityStore.search(for: query)
            searchResults = results
            isLoading = false
            
            if results.isEmpty {
                errorMessage = "No cities found matching '\(query)'"
            }
        } catch {
            errorMessage = "Search failed: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func selectCity(_ city: City) {
        selectedCity = city
        searchText = ""
        searchResults = []
        errorMessage = nil
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
        errorMessage = nil
        selectedCity = nil
    }
}
