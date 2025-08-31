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
    let store = try! InMemoryCityStore(jsonString: SampleData.citiesJSON)
    let viewModel = CitySearchViewModel(cityStore: store)
    
    return CitySearchMapView(viewModel: viewModel)
}
