//
//  CitySearchMapView.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import SwiftUI

struct CitySearchMapView: View {
    @ObservedObject var viewModel: CitySearchViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            // Map takes full screen
            GoogleMapView(viewModel: viewModel)
                .ignoresSafeArea(.container, edges: .bottom)
            
            // Search overlay
            VStack(spacing: 0) {
                SearchinputView(viewModel: viewModel)
                    .background(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                
                Spacer()
            }
            .zIndex(1)
        }
    }
}

#Preview {
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
        }
    ]
    """
    
    let store = try! InMemoryCityStore(jsonString: sampleCities)
    let viewModel = CitySearchViewModel(cityStore: store)
    
    return CitySearchMapView(viewModel: viewModel)
}
