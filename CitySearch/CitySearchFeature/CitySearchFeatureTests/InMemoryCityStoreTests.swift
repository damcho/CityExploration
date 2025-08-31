//
//  CitySearchFeatureTests.swift
//  CitySearchFeatureTests
//
//  Created by Damian Modernell on 31/8/25.
//

import Testing
import Foundation

struct City: Equatable {
    let name: String
}

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
            city.name.starts(with: searchPrefix)
        }
    }
}

struct InMemoryCityStoreTests {

    @Test func empty_results_on_unmatching_search_prefix() async throws {
        let sut = makeSUT()
        
        let searchPrefix = "buenos ai"
        
        #expect(sut.search(searchPrefix).isEmpty)
    }
    
    @Test func finds_city_on_matching_result() async throws {
        let expectedCity = city(name: "buenos aires")
        let sut = makeSUT(cities: String(data: try! JSONSerialization.data(
            withJSONObject: [expectedCity.raw], options: []), encoding: .utf8)!)
        
        let searchPrefix = "buenos ai"
        
        #expect(sut.search(searchPrefix) == [expectedCity.model])
    }
}

extension InMemoryCityStoreTests {
    
    private func makeSUT(cities: String = "[]") -> InMemoryCityStore {
        return try! InMemoryCityStore(jsonString: cities)
    }
}

func city(name: String) -> (model: City, raw: [String: Any]) {
    (
        City(name: name),
        ["country": "", "name": name, "_id": 0, "coord": ["lon": 0.0, "lat": 0.0]]
    )
}
