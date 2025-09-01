//
//  CityCardView.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import SwiftUI

struct CityCardView: View {
    @ObservedObject var cardViewModel: CityCardViewModel
    
    init(cardViewModel: CityCardViewModel) {
        self.cardViewModel = cardViewModel
    }
    
    var body: some View {
        if let selectedCity = cardViewModel.selectedCity {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(selectedCity.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text(selectedCity.country)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("Lat: \(String(format: "%.4f", selectedCity.latitude)), Lon: \(String(format: "%.4f", selectedCity.longitude))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            FavoriteButton(city: selectedCity, viewModel: cardViewModel)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .padding(.trailing, 16)
                }
                .padding(.bottom, 100)
            }
        }
    }
}

struct FavoriteButton: View {
    let city: City
    @ObservedObject var viewModel: CityCardViewModel
    
    var body: some View {
        Button(action: {
            viewModel.toggleFavorite(for: city)
        }) {
            Image(systemName: viewModel.isSelectedCityFavorite ? "heart.fill" : "heart")
                .font(.title2)
                .foregroundColor(viewModel.isSelectedCityFavorite ? .red : .gray)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(viewModel.isSelectedCityFavorite ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isSelectedCityFavorite)
    }
}
