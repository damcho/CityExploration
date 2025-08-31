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
        VStack(spacing: 0) {
            SearchinputView(viewModel: viewModel)
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                .zIndex(1)
            
            GoogleMapView()
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

#Preview {
    let sampleCities = """
    [
        {"name": "Buenos Aires"},
        {"name": "Barcelona"},
        {"name": "Berlin"},
        {"name": "Boston"},
        {"name": "Bangkok"},
        {"name": "Beijing"}
    ]
    """
    
    let store = try! InMemoryCityStore(jsonString: sampleCities)
    let viewModel = CitySearchViewModel(cityStore: store)
    
    return CitySearchMapView(viewModel: viewModel)
}
