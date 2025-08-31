//
//  CitySearchApp.swift
//  CitySearch
//
//  Created by Damian Modernell on 31/8/25.
//

import SwiftUI
import CitySearchFeature

@main
struct CitySearchApp: App {
    var body: some Scene {
        WindowGroup {
            try! CitySearchComposer.compose()
        }
    }
}
