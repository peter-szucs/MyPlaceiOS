//
//  MapViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-05.
//

import SwiftUI
import MapKit
import CoreLocation

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var mapView = MKMapView()
    @Published var navBarHidden = true
    @Published var region: MKCoordinateRegion!
    @Published var permissionDenied = false
    @Published var mapType: MKMapType = .standard
    @Published var centerCoordinate = CLLocationCoordinate2D()
    @Published var annotations: [MKPointAnnotation] = []
    @Published var goToAddPlace = false
    @Published var newPlace: Place = Place()
    
    // Change map type
    func updateMapType() {
        if mapType == .standard {
            mapType = .hybrid
            mapView.mapType = mapType
        } else {
            mapType = .standard
            mapView.mapType = mapType
        }
    }
    
    // Focus on location
    func focusLocation() {
        guard let _ = region else { return }
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    func addPlace(coordinate: CLLocationCoordinate2D) {
        
        convertCoordinateToAddress(location: coordinate) { (placemark, error) in
            if let error = error as? CLError {
                print("CLError: \(error)")
                return
            } else if let placemark = placemark?.first {
                // MARK: TODO: Rewrite with enums in PlaceMarkAddress Struct
                self.newPlace.PMData = PlaceMarkAddress(name: placemark.name, thoroughfare: placemark.thoroughfare, subThoroughfare: placemark.subThoroughfare, postalCode: placemark.postalCode, subLocality: placemark.subLocality, administrativeArea: placemark.administrativeArea, country: placemark.country)
                self.newPlace.lat = coordinate.latitude
                self.newPlace.lng = coordinate.longitude
                print(self.newPlace)
                self.goToAddPlace = true
            }
        }
//        let pointAnnotation = MKPointAnnotation()
//        pointAnnotation.coordinate = coordinate
//        pointAnnotation.title = "Annotation"
//        pointAnnotation.subtitle = "This is a pin"
//        annotations.append(pointAnnotation)
//        mapView.addAnnotation(pointAnnotation)
        
        // Move map to location
//        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 50, longitudinalMeters: 50)
//        mapView.setRegion(coordinateRegion, animated: true)
//        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    func convertCoordinateToAddress(location: CLLocationCoordinate2D, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> ()) {
        let geoCoder = CLGeocoder()
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geoCoder.reverseGeocodeLocation(clLocation) { (placemark, error) -> Void in
//            if (error != nil) {
//                print("!!! reverse geocode failed: \(String(describing: error?.localizedDescription))")
//            }
            guard let placemark = placemark, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
//            for i in 0..<placemarks!.count {
//                placeMark = placemarks?[i]
//
                // MARK: - So it seems you need to either switch to Google Maps or use API from google maps (Places SDK) on the coordinate to get the business name and all other good stuff...
                
//                print("!!! name: \(placemarks![i].name), address: \(placeMark.thoroughfare) \(placeMark.postalCode) \(placeMark.subLocality) \(placeMark.administrativeArea) \(placeMark.country), subAdmin: \(placeMark.subAdministrativeArea)")
//            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Check persmissions
        switch manager.authorizationStatus {
        case .denied:
            permissionDenied.toggle()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.requestLocation()
        default:
            
            ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("!!! didupdateloc")
        guard let location = locations.last else { return }
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        
        self.mapView.setRegion(self.region, animated: true)
        
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
}
