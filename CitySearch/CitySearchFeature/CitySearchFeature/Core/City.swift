//
//  City.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation

struct City: Equatable, Identifiable {
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
    let id: Int
}
