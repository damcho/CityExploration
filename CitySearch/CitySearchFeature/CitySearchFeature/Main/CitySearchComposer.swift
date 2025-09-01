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
        
        let cityStore = try InMemoryCityStore(jsonFileName: "cities")
        let favoritesManager = UserDefaultsFavoriteCityManager()
        
        let searchViewModel = CitySearchViewModel(cityStore: cityStore)
        let cardViewModel = CityCardViewModel(favoritesManager: favoritesManager)
        let favoritesViewModel = FavoritesViewModel(favoritesManager: favoritesManager)
        
        let onCitySelectedCallback: (City) -> Void = { city in
            searchViewModel.selectCity(city)
            cardViewModel.selectCity(city)
        }
        
        let mapView = GoogleMapView(viewModel: searchViewModel)
        let cityCardView = CityCardView(cardViewModel: cardViewModel)
        let searchInputView = SearchinputView(viewModel: searchViewModel, onCitySelected: onCitySelectedCallback)
        let favoritesView = FavoritesView(viewModel: favoritesViewModel) { selectedCity in
            onCitySelectedCallback(selectedCity)
        }
        
        return CitySearchMapView(
            mapView: mapView,
            cityCardView: cityCardView,
            searchInputView: searchInputView,
            favoritesView: favoritesView,
            onCitySelected: onCitySelectedCallback
        )
    }
}
