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
    private let favoritesView: FavoritesContent
    private let onCitySelected: (City) -> Void
    
    @State private var showFavorites = false
    
    init(
        mapView: MapView,
        cityCardView: CityCard,
        searchInputView: SearchInput,
        favoritesView: FavoritesContent,
        onCitySelected: @escaping (City) -> Void
    ) {
        self.mapView = mapView
        self.cityCardView = cityCardView
        self.searchInputView = searchInputView
        self.favoritesView = favoritesView
        self.onCitySelected = onCitySelected
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // Map layer (background)
            mapView
                .ignoresSafeArea(.container, edges: .bottom)
            
            // City card overlay
            cityCardView
                .zIndex(1)
            
            // UI controls layer (top)
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
                .zIndex(3)
                
                searchInputView
                    .background(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                
                Spacer()
            }
            .zIndex(2)
        }
        .sheet(isPresented: $showFavorites) {
            favoritesView
                .onAppear {
                    // Handle any setup needed when favorites view appears
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
