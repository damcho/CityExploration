//
//  InMemoryCityStore.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation

enum CitySearchError: Error {
    case decoding
    case fileNotFound
    case invalidData
}

final class PrefixTreeInMemoryCityStore {
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
    
    class PrefixNode {
        var children: [Character: PrefixNode] = [:]
        var cities: [City] = []
    }
    
    private let root = PrefixNode()
        
    init(jsonString: String) throws {
        guard let citiesData = jsonString.data(using: .utf8) else {
            throw CitySearchError.decoding
        }
        try initializePrefixTree(for: citiesData)

    }
    
    init(jsonFileName: String, bundle: Bundle = Bundle(for: PrefixTreeInMemoryCityStore.self),
    ) throws {
        guard let fileURL = bundle.url(forResource: jsonFileName, withExtension: "json") else {
            throw CitySearchError.fileNotFound
        }
        
        guard let citiesData = try? Data(contentsOf: fileURL) else {
            throw CitySearchError.invalidData
        }
        
       try initializePrefixTree(for: citiesData)
    }
}

private extension PrefixTreeInMemoryCityStore {
    func insert(_ city: City) {
        var current = root
        for char in city.name.lowercased() {
            if current.children[char] == nil {
                current.children[char] = PrefixNode()
            }
            current = current.children[char]!
            current.cities.append(city)
        }
    }
    
    func initializePrefixTree(for citiesJsonData: Data) throws {
        _ = try JSONDecoder().decode(
            [DecodableCity].self,
            from: citiesJsonData
        ).map({
            insert($0.toCity())
        })
    }
    
    func isLastSearchPrefixCharacter(_ index: Int, in searchPrefix: [Character]) -> Bool {
        index == searchPrefix.count
    }
    
    func getNextNode(for node: PrefixNode, prefix: [Character], at prefixIndex: Int) -> PrefixNode? {
        guard let nextNode = node.children[prefix[prefixIndex]] else {
            return nil
        }
        return nextNode
    }
    
    func seach(_ node: PrefixNode, for prefix: [Character], at prefixIndex: Int) -> [City] {
        if isLastSearchPrefixCharacter(prefixIndex, in: prefix) {
            return node.cities
        }
        guard let nextNode = getNextNode(for: node, prefix: prefix, at: prefixIndex) else {
            return []
        }
        return seach(nextNode, for: prefix, at: prefixIndex + 1)
    }
}

extension PrefixTreeInMemoryCityStore: CitySearchable {
    func search(for searchPrefix: String) async throws -> [City] {
        seach(root, for: searchPrefix.lowercased().map(\.self), at: 0)
    }
}
