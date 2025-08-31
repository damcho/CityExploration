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

        let sampleCities = """
        [
            {
                "name": "Buenos Aires",
                "coord": {
                    "lat": -34.6037,
                    "lon": -58.3816
                }
            },
            {
                "name": "Barcelona",
                "coord": {
                    "lat": 41.3851,
                    "lon": 2.1734
                }
            },
            {
                "name": "Berlin",
                "coord": {
                    "lat": 52.5200,
                    "lon": 13.4050
                }
            },
            {
                "name": "Boston",
                "coord": {
                    "lat": 42.3601,
                    "lon": -71.0589
                }
            },
            {
                "name": "Bangkok",
                "coord": {
                    "lat": 13.7563,
                    "lon": 100.5018
                }
            },
            {
                "name": "Beijing",
                "coord": {
                    "lat": 39.9042,
                    "lon": 116.4074
                }
            },
            {
                "name": "Brasília",
                "coord": {
                    "lat": -15.7942,
                    "lon": -47.8822
                }
            },
            {
                "name": "Brussels",
                "coord": {
                    "lat": 50.8503,
                    "lon": 4.3517
                }
            },
            {
                "name": "Bucharest",
                "coord": {
                    "lat": 44.4268,
                    "lon": 26.1025
                }
            },
            {
                "name": "Budapest",
                "coord": {
                    "lat": 47.4979,
                    "lon": 19.0402
                }
            }
        ]
        """
        
        let cityStore = try InMemoryCityStore(jsonString: sampleCities)
        let viewModel = CitySearchViewModel(cityStore: cityStore)
        
        return CitySearchMapView(viewModel: viewModel)
    }
}
