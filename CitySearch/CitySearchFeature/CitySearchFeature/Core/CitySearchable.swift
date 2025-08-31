//
//  CitySearchable.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation

protocol CitySearchable {
    func search(for query: String) async throws -> [City]
}
