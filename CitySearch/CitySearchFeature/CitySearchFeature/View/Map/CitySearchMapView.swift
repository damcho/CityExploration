//
//  CitySearchMapView.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import SwiftUI

struct CitySearchMapView: View {
    @ObservedObject var searchViewModel: CitySearchViewModel
    @ObservedObject var cardViewModel: CityCardViewModel
    @ObservedObject var favoritesViewModel: FavoritesViewModel
    @State private var showFavorites = false
    
    var body: some View {
        ZStack(alignment: .top) {
            CityCardView(searchViewModel: searchViewModel, cardViewModel: cardViewModel)
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
                
                SearchinputView(viewModel: searchViewModel)
                    .background(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                
                Spacer()
            }
            .zIndex(1)
        }
        .sheet(isPresented: $showFavorites) {
            FavoritesView(viewModel: favoritesViewModel) { selectedCity in
                searchViewModel.selectCity(selectedCity)
                showFavorites = false
            }
        }
    }
}

#Preview {
    let store = try! InMemoryCityStore(jsonString: SampleData.citiesJSON)
    let favoritesManager = UserDefaultsFavoriteCityManager()
    let searchViewModel = CitySearchViewModel(cityStore: store)
    let cardViewModel = CityCardViewModel(favoritesManager: favoritesManager)
    let favoritesViewModel = FavoritesViewModel(favoritesManager: favoritesManager)
    
    return CitySearchMapView(
        searchViewModel: searchViewModel,
        cardViewModel: cardViewModel,
        favoritesViewModel: favoritesViewModel
    )
}
