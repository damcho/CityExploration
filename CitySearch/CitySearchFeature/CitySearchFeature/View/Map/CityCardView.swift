//
//  CityCardView.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import SwiftUI

struct CityCardView: View {
    @ObservedObject var searchViewModel: CitySearchViewModel
    @ObservedObject var cardViewModel: CityCardViewModel
    
    var body: some View {
        ZStack {
            GoogleMapView(viewModel: searchViewModel)
            
            // City info card overlay with favorites button
            if let selectedCity = searchViewModel.selectedCity {
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
                                
                                // Favorites button
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
}

struct FavoriteButton: View {
    let city: City
    @ObservedObject var viewModel: CityCardViewModel
    @State private var isFavorite = false
    @State private var updateTrigger = 0
    
    var body: some View {
        Button(action: {
            viewModel.toggleFavorite(for: city)
            updateTrigger += 1
        }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.title2)
                .foregroundColor(isFavorite ? .red : .gray)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isFavorite ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isFavorite)
        .task {
            isFavorite = await viewModel.isFavorite(city)
        }
        .task(id: updateTrigger) {
            if updateTrigger > 0 {
                // Small delay to ensure the toggle has completed
                try? await Task.sleep(for: .milliseconds(50))
                isFavorite = await viewModel.isFavorite(city)
            }
        }
    }
}
