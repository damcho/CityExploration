//
//  CitySearchMapView.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import SwiftUI

struct CitySearchMapView: View {
    @ObservedObject var viewModel: CitySearchViewModel
    @State private var showFavorites = false
    @State private var favoritesViewModel: FavoritesViewModel?
    
    private func getFavoritesViewModel() -> FavoritesViewModel {
        if let existing = favoritesViewModel {
            return existing
        }
        let newViewModel = FavoritesViewModel(
            favoritesManager: viewModel.favoritesManager
        )
        favoritesViewModel = newViewModel
        return newViewModel
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            CityCardView(viewModel: viewModel)
                .ignoresSafeArea(.container, edges: .bottom)
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showFavorites = true
                    }) {
                        Image(systemName: "heart.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                            .padding(12)
                            .background(Color(.systemBackground))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
                    .padding(.trailing, 16)
                }
                .zIndex(2)
                
                SearchinputView(viewModel: viewModel)
                    .background(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                
                Spacer()
            }
            .zIndex(1)
        }
        .sheet(isPresented: $showFavorites) {
            FavoritesView(viewModel: getFavoritesViewModel()) { selectedCity in
                viewModel.selectCity(selectedCity)
                showFavorites = false
            }
        }
    }
}

#Preview {
    let store = try! InMemoryCityStore(jsonString: SampleData.citiesJSON)
    let favoritesManager = UserDefaultsFavoriteCityManager()
    let viewModel = CitySearchViewModel(cityStore: store, favoritesManager: favoritesManager)
    
    return CitySearchMapView(viewModel: viewModel)
}
