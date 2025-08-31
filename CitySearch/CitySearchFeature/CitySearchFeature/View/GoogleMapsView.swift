//
//  GoogleMapsView.swift
//  CitySearchFeature
//
//  Created by Damian Modernell on 31/8/25.
//

import Foundation
import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(
            withLatitude: -34.6037,
            longitude: -58.3816,
            zoom: 12
        )
        let mapView = GMSMapView()
        mapView.camera = camera
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
    }
}
