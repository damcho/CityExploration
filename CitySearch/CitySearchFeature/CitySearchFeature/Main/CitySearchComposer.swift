//
//  CitySearchComposer.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation
import SwiftUI
import GoogleMaps

public enum CitySearchComposer {
    @MainActor
    static public func compose() throws -> some View {
        GMSServices.provideAPIKey("AIzaSyAVIvISQPshSOtqRHKu7eZ3zrARhXC6bMI")
        
        let cityStore = try InMemoryCityStore(jsonString: SampleData.citiesJSON)
        let favoritesManager = UserDefaultsFavoriteCityManager()
        
        let searchViewModel = CitySearchViewModel(cityStore: cityStore)
        let cardViewModel = CityCardViewModel(favoritesManager: favoritesManager)
        let favoritesViewModel = FavoritesViewModel(favoritesManager: favoritesManager)
        
        // Create the subviews
        let mapView = GoogleMapView(viewModel: searchViewModel)
        let cityCardView = CityCardView(
            selectedCity: Binding(
                get: { searchViewModel.selectedCity },
                set: { searchViewModel.selectedCity = $0 }
            ),
            cardViewModel: cardViewModel
        )
        let searchInputView = SearchinputView(viewModel: searchViewModel)
        let favoritesView = FavoritesView(viewModel: favoritesViewModel) { selectedCity in
            searchViewModel.selectCity(selectedCity)
        }
        
        return CitySearchMapView(
            mapView: mapView,
            cityCardView: cityCardView,
            searchInputView: searchInputView,
            favoritesView: favoritesView,
            onCitySelected: { city in
                searchViewModel.selectCity(city)
            }
        )
    }
}
