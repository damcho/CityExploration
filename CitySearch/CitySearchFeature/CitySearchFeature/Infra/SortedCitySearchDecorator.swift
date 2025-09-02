//
//  SortedCitySearchDecorator.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation

final class SortedCitySearchDecorator: CitySearchable {
    private let decoratee: CitySearchable
    
    init(decoratee: CitySearchable) {
        self.decoratee = decoratee
    }
    
    func search(for query: String) async throws -> [City] {
        let results = try await decoratee.search(for: query)
        
        return results.sorted { lhs, rhs in
            // First sort by city name
            let nameComparison = lhs.name.localizedCompare(rhs.name)
            if nameComparison != .orderedSame {
                return nameComparison == .orderedAscending
            }
            
            // If city names are equal, sort by country
            return lhs.country.localizedCompare(rhs.country) == .orderedAscending
        }
    }
}
