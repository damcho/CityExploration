//
//  SearchPolicy.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation

protocol SearchPolicy {
    func shouldExecuteSearch(for query: String) -> Bool
}

struct MinimumCharacterSearchPolicy: SearchPolicy {
    private let minimumCharacters: Int
    
    init(minimumCharacters: Int = 3) {
        self.minimumCharacters = minimumCharacters
    }
    
    func shouldExecuteSearch(for query: String) -> Bool {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedQuery.count >= minimumCharacters
    }
}
