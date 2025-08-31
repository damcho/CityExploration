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
    
    private let cityStore: CitySearchable
    private var cancellables = Set<AnyCancellable>()
    
    init(cityStore: CitySearchable) {
        self.cityStore = cityStore
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
        errorMessage = nil
    }
}
