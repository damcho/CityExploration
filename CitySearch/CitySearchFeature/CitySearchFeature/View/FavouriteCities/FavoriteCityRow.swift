//
//  FavoriteCityRow.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import SwiftUI

struct FavoriteCityRow: View {
    let city: City
    let onTap: () -> Void
    @ObservedObject var viewModel: FavoritesViewModel
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                // City icon
                Image(systemName: "location.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(city.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(city.country)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Lat: \(String(format: "%.4f", city.latitude)), Lon: \(String(format: "%.4f", city.longitude))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Remove from favorites button
                Button(action: {
                    viewModel.removeFavorite(city)
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let sampleCity = City(
        name: "Paris",
        country: "FR",
        latitude: 48.8566,
        longitude: 2.3522,
        id: 1
    )
    
    let favoritesManager = UserDefaultsFavoriteCityManager()
    let viewModel = FavoritesViewModel(favoritesManager: favoritesManager)
    
    return FavoriteCityRow(city: sampleCity, onTap: {
        print("City tapped: \(sampleCity.name)")
    }, viewModel: viewModel)
    .padding()
}
