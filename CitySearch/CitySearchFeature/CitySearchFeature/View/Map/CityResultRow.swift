//
//  CityResultRow.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import SwiftUI

struct CityResultRow: View {
    let city: City
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: "location.circle")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(city.name)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Text(city.country)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let sampleCity = City(
        name: "London",
        country: "GB",
        latitude: 51.5074,
        longitude: -0.1278,
        id: 1
    )
    
    return CityResultRow(city: sampleCity) {
        print("City tapped: \(sampleCity.name)")
    }
    .padding()
}
