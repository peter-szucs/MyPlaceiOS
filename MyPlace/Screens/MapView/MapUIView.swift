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
    @Binding var centerCoordinate: CLLocationCoordinate2D
    var annotations: [MKPointAnnotation]
//    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    func makeCoordinator() -> Coordinator {
//        return MapUIView.Coordinator()
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        let view = viewModel.mapView
        
        view.showsUserLocation = true
        view.delegate = context.coordinator
        
        return view
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        var pins = [MKAnnotation]()
        for pin in view.annotations {
            if !(pin.isKind(of: MKUserLocation.self)) {
                pins.append(pin)
            }
        }
        
        if annotations.count != pins.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapUIView
        
        init(_ parent: MapUIView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            // Custom Pins
            
            if annotation.isKind(of: MKUserLocation.self) {
                return nil
            } else {
                var pinAnnotation: MKAnnotationView?
                if let dequedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PIN") {
                    pinAnnotation = dequedAnnotationView
                    pinAnnotation?.annotation = annotation
                } else {
                    pinAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: "PIN")
                    pinAnnotation?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                }
                
                if let pinAnnotation = pinAnnotation {
                    pinAnnotation.canShowCallout = true
                    pinAnnotation.image = UIImage(named: "Logo")
                }
                
//                let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
//                pinAnnotation.tintColor = .red
//                pinAnnotation.animatesDrop = true
//                pinAnnotation.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//                pinAnnotation.canShowCallout = true
//                pinAnnotation.pinTintColor = .blue
//                pinAnnotation.image = UIImage(named: "Logo")
                
                return pinAnnotation
            }
            
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
    }
}

