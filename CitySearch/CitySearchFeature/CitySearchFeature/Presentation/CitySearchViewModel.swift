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
    @Published var searchState: CitiesState = .empty
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
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
    
        guard searchPolicy.shouldExecuteSearch(for: trimmedQuery) else {
            return
        }
        
        do {
            searchState = .loading

            let results = try await cityStore.search(for: query)
            
            if results.isEmpty {
                searchState = .error("No cities found matching '\(query)'")
            } else {
                searchState = .loaded(results)
            }
        } catch {
            searchState = .error("Search failed: \(error.localizedDescription)")
        }
    }
    
    func selectCity(_ city: City) {
        selectedCity = city
        searchText = ""
        searchState = .empty
    }
    
    func clearSearch() {
        searchText = ""
        searchState = .empty
        selectedCity = nil
    }
}
