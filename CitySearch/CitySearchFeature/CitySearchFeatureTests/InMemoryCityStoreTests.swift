//
//  CitySearchFeatureTests.swift
//  CitySearchFeatureTests
//
//  Created by Damian Modernell on 31/8/25.
//

import Testing
import Foundation
@testable import CitySearchFeature

struct InMemoryCityStoreTests {

    @Test func empty_results_on_unmatching_search_prefix() async throws {
        let sut = makeSUT()
        
        let searchPrefix = "buenos ai"
        
        try await #expect(sut.search(for: searchPrefix).isEmpty)
    }
    
    @Test func finds_city_on_matching_result() async throws {
        let expectedCity = city(name: "buenos aires")
        let sut = makeSUT(cities: String(data: try! JSONSerialization.data(
            withJSONObject: [expectedCity.raw], options: []), encoding: .utf8)!)
        
        let searchPrefix = "buenos ai"
        
        try await #expect(sut.search(for: searchPrefix) == [expectedCity.model])
    }
    
    @Test func finds_city_on_uppercase_prefix() async throws {
        let expectedCity = city(name: "buenos aires")
        let sut = makeSUT(cities: String(data: try! JSONSerialization.data(
            withJSONObject: [expectedCity.raw], options: []), encoding: .utf8)!)
        
        let uppercaseSearchPrefix = "BUENOS AI"
        
        try await #expect(sut.search(for: uppercaseSearchPrefix) == [expectedCity.model])
    }
    
    @Test func finds_multiple_results_on_matching_prefix() async throws {
        let expectedCities = [
            city(name: "New York"),
            city(name: "New Orleans")
        ]
        
        let storeCities = [
            city(name: "New York"),
            city(name: "New Orleans"),
            city(name: "Buenos Aires"),
        ]

        
        let sut = makeSUT(cities: String(data: try! JSONSerialization.data(
            withJSONObject: storeCities.map({ $0.raw }), options: []), encoding: .utf8)!)

        let searchPrefix = "new"
        
        try await #expect(sut.search(for: searchPrefix) == expectedCities.map({$0.model}))
    }
}

extension InMemoryCityStoreTests {
    
    private func makeSUT(cities: String = "[]") -> InMemoryCityStore {
        return try! InMemoryCityStore(jsonString: cities)
    }
}

func city(name: String) -> (model: City, raw: [String: Any]) {
    (
        City(name: name, country: "",latitude: 0.0, longitude: 0.0),
        ["country": "", "name": name, "_id": 0, "coord": ["lon": 0.0, "lat": 0.0]]
    )
}
