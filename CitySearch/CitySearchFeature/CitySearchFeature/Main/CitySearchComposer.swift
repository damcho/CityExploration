//
//  CitySearchComposer.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation
import SwiftUI
import GoogleMaps

public enum CitySearchComposer {
    static public func compose() -> some View {
        GMSServices.provideAPIKey("AIzaSyAVIvISQPshSOtqRHKu7eZ3zrARhXC6bMI")

        return CitySearchMapView()
    }
}
