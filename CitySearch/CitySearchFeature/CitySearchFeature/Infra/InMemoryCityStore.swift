//
//  InMemoryCityStore.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation

enum CitySearchError: Error {
    case decoding
}

struct InMemoryCityStore {
    struct DecodableCoordinate: Decodable {
        let lat: Double
        let lon: Double
    }
    struct DecodableCity: Decodable {
        let name: String
        let coord: DecodableCoordinate
        let country: String
        
        func toCity() -> City {
            City(name: name, country: country, latitude: coord.lat, longitude: coord.lon)
        }
    }
    
    let cities: [City]
    
    init(jsonString: String) throws {
        guard let citiesData = jsonString.data(using: .utf8) else {
            throw CitySearchError.decoding
        }
        self.cities = try JSONDecoder().decode(
            [DecodableCity].self,
            from: citiesData
        ).map({ $0.toCity() })
    }
}

extension InMemoryCityStore: CitySearchable {
    func search(for searchPrefix: String) async throws -> [City] {
        cities.filter { city in
            city.name.lowercased().starts(with: searchPrefix.lowercased())
        }
    }
}
