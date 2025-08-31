//
//  CityCardView.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import SwiftUI

struct CityCardView: View {
    @ObservedObject var viewModel: CitySearchViewModel
    
    var body: some View {
        ZStack {
            GoogleMapView(viewModel: viewModel)
            
            // City info card overlay with favorites button
            if let selectedCity = viewModel.selectedCity {
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
                                Button(action: {
                                    viewModel.toggleFavorite(for: selectedCity)
                                }) {
                                    Image(systemName: viewModel.isFavorite(selectedCity) ? "heart.fill" : "heart")
                                        .font(.title2)
                                        .foregroundColor(viewModel.isFavorite(selectedCity) ? .red : .gray)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .scaleEffect(viewModel.isFavorite(selectedCity) ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: viewModel.isFavorite(selectedCity))
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
