//
//  CitySearchFeatureTests.swift
//  CitySearchFeatureTests
//
//  Created by Damian Modernell on 31/8/25.
//

import Testing

struct City {
    
}

struct InMemoryCityStore {
    func search(_ searchPrefix: String) -> [City] {
        []
    }
}

struct InMemoryCityStoreTests {

    @Test func empty_results_on_unmatching_search_prefix() async throws {
        let sut = makeSUT()
        
        let searchPrefix = "buenos ai"
        
        #expect(sut.search(searchPrefix).isEmpty)
    }

}

extension InMemoryCityStoreTests {
    
    private func makeSUT() -> InMemoryCityStore {
        return .init()
    }
}
