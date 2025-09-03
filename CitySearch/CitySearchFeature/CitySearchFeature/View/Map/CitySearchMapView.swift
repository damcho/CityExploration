//
//  CitySearchMapView.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import SwiftUI

struct CitySearchMapView<MapView: View, CityCard: View, SearchInput: View, FavoritesContent: View>: View {
    private let mapView: MapView
    private let cityCardView: CityCard
    private let searchInputView: SearchInput
    private let favoritesViewBuilder: (@escaping () -> Void) -> FavoritesContent
    private let onCitySelected: (City) -> Void
    
    @State private var showFavorites = false
    
    init(
        mapView: MapView,
        cityCardView: CityCard,
        searchInputView: SearchInput,
        favoritesViewBuilder: @escaping (@escaping () -> Void) -> FavoritesContent,
        onCitySelected: @escaping (City) -> Void
    ) {
        self.mapView = mapView
        self.cityCardView = cityCardView
        self.searchInputView = searchInputView
        self.favoritesViewBuilder = favoritesViewBuilder
        self.onCitySelected = onCitySelected
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            mapView
                .ignoresSafeArea(.container, edges: .bottom)
            
            cityCardView
                .zIndex(1)
            
            VStack(spacing: 12) {
                searchInputView
                    .background(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showFavorites = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "heart.fill")
                                .font(.title3)
                                .foregroundColor(.red)
                            
                            Text("Favorites")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .zIndex(2)
        }
        .sheet(isPresented: $showFavorites) {
            favoritesViewBuilder {
                showFavorites = false
            }
        }
    }
}

#Preview {
    let store = try! PrefixTreeInMemoryCityStore(jsonString: SampleData.citiesJSON)
    let favoritesManager = UserDefaultsFavoriteCityManager()
    let searchViewModel = CitySearchViewModel(cityStore: store, searchPolicy: MinimumCharacterSearchPolicy())
    let cardViewModel = CityCardViewModel(favoritesManager: favoritesManager)
    let favoritesViewModel = FavoritesViewModel(favoritesManager: favoritesManager)
    
    let onCitySelectedCallback: (City) -> Void = { city in
        searchViewModel.selectCity(city)
        cardViewModel.selectCity(city)
    }
    
    let mapView = GoogleMapView(viewModel: searchViewModel)
    let cityCardView = CityCardView(cardViewModel: cardViewModel)
    let searchInputView = SearchinputView(viewModel: searchViewModel, onCitySelected: onCitySelectedCallback)
    return CitySearchMapView(
        mapView: mapView,
        cityCardView: cityCardView,
        searchInputView: searchInputView,
        favoritesViewBuilder: { onDismiss in
            FavoritesView(
                viewModel: favoritesViewModel,
                onCitySelected: { city in
                    onCitySelectedCallback(city)
                },
                onDismiss: onDismiss
            )
        },
        onCitySelected: onCitySelectedCallback
    )
}
