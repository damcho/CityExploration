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
        let viewModel = CitySearchViewModel(cityStore: cityStore, favoritesManager: favoritesManager)
        
        return CitySearchMapView(viewModel: viewModel)
    }
}
