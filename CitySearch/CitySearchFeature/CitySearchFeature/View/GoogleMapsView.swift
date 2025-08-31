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
    @ObservedObject var viewModel: CitySearchViewModel
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(
            withLatitude: -34.6037,
            longitude: -58.3816,
            zoom: 12
        )
        let mapView = GMSMapView()
        mapView.camera = camera
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
        mapView.settings.scrollGestures = true
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Clear existing markers
        uiView.clear()
        
        // If a city is selected, center the map and add a marker
        if let selectedCity = viewModel.selectedCity {
            let position = CLLocationCoordinate2D(
                latitude: selectedCity.latitude,
                longitude: selectedCity.longitude
            )
            
            // Animate camera to the selected city
            let camera = GMSCameraPosition.camera(
                withLatitude: selectedCity.latitude,
                longitude: selectedCity.longitude,
                zoom: 14
            )
            uiView.animate(to: camera)
            
            // Add marker for the selected city
            let marker = GMSMarker()
            marker.position = position
            marker.title = selectedCity.name
            marker.snippet = "Latitude: \(String(format: "%.4f", selectedCity.latitude)), Longitude: \(String(format: "%.4f", selectedCity.longitude))"
            marker.icon = GMSMarker.markerImage(with: .systemRed)
            marker.map = uiView
        }
    }
}
