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
        uiView.clear()
        
        if let selectedCity = viewModel.selectedCity {
            let position = CLLocationCoordinate2D(
                latitude: selectedCity.latitude,
                longitude: selectedCity.longitude
            )
            
            let camera = GMSCameraPosition.camera(
                withLatitude: selectedCity.latitude,
                longitude: selectedCity.longitude,
                zoom: 14
            )
            uiView.animate(to: camera)
            
            let marker = GMSMarker()
            marker.position = position
            marker.title = selectedCity.name
            marker.snippet = "Latitude: \(String(format: "%.4f", selectedCity.latitude)), Longitude: \(String(format: "%.4f", selectedCity.longitude))"
            marker.icon = GMSMarker.markerImage(with: .systemRed)
            marker.map = uiView
        }
    }
}
