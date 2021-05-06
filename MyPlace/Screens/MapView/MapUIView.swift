//
//  MapUIView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-05.
//

import SwiftUI
import MapKit

struct MapUIView: UIViewRepresentable {
    
    @EnvironmentObject var viewModel: MapViewModel
    
    func makeCoordinator() -> Coordinator {
        return MapUIView.Coordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        let view = viewModel.mapView
        
        view.showsUserLocation = true
        view.delegate = context.coordinator
        
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
    }
}

