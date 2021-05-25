//
//  MapUIView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-05.
//

import SwiftUI
import UIKit
import MapKit

struct MapUIView: UIViewRepresentable {
    
    @EnvironmentObject var viewModel: MapViewModel
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var placeID: String
    @Binding var friendID: String
//    var annotations: [MKPointAnnotation]
    
    var annotations: [MKAnnotation]
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
            let button = UIButton(type: .detailDisclosure)
            if annotation.isKind(of: MKUserLocation.self) {
                return nil
            } else {
//                var pinAnnotation: MKAnnotationView?
//                if let dequedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PIN") {
//                    pinAnnotation = dequedAnnotationView
//                    pinAnnotation?.annotation = annotation
//                } else {
//                    pinAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: "PIN_ELSE")
//                    pinAnnotation?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//                }
//
//                if let pinAnnotation = pinAnnotation {
//                    pinAnnotation.canShowCallout = true
//                    pinAnnotation.rightCalloutAccessoryView = button
//                    pinAnnotation.image = UIImage(named: "Logo")
//                }
                if annotation is PlaceAnnotation {
                    let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
    //                pinAnnotation.tintColor = .red
                    pinAnnotation.animatesDrop = true
                    pinAnnotation.rightCalloutAccessoryView = button
                    pinAnnotation.canShowCallout = true
    //                pinAnnotation.pinTintColor = .blue
                    
                    button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
                    
                    return pinAnnotation
                }
                let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
//                pinAnnotation.tintColor = .red
                pinAnnotation.animatesDrop = true
                pinAnnotation.rightCalloutAccessoryView = button
                pinAnnotation.canShowCallout = true
//                pinAnnotation.pinTintColor = .blue
                
                button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
                
                return pinAnnotation
            }
            
        }
        
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            let a = view.annotation as! PlaceAnnotation
            print("\(view.annotation?.title), \(a.id)")
            // Combine for this maybe? Getting all info but cant get it into viewmodel (like below)
//            viewModel.goToPlaceDetailView(for: a.id, in: a.friendID)
            parent.placeID = a.id
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.parent.friendID = a.friendID
            }
            
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        @objc func buttonAction() {
//            print("Tapped")
        }
    }
}
