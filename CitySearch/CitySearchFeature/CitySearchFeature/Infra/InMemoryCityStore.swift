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
    struct DecodableCity: Decodable {
        let name: String
        
        func toCity() -> City {
            City(name: name)
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
    
    func search(_ searchPrefix: String) -> [City] {
        cities.filter { city in
            city.name.lowercased().starts(with: searchPrefix.lowercased())
        }
    }
}
