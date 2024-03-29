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
//    @Published var annotations: [MKPointAnnotation] = []
    @Published var annotations: [MKAnnotation] = []
    @Published var goToAddPlace = false
    @Published var newPlace: Place = Place()
    @Published var friendsList: [Friend] = []
    
    @Published var goToPlaceDetail = false
    @Published var placeDetailPlace: Place = Place()
    
    @Published var placeID: String = ""
    @Published var friendID: String = "" {
        didSet {
            print("### didSet for gotoplacedetailview: p: \(placeID), f: \(friendID) ###")
            goToPlaceDetailView(for: placeID, in: friendID)
        }
    }
    
    @Published var currentFilters = MapFilters()
    @Published var recievedFilters: MapFilters = MapFilters() {
        didSet {
            print("!!! didSet filters: \(recievedFilters)")
            // fetch
            setupMapWithFilters()
        }
    }
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var filteredFriends: [Friend] = []
    
//    init(friendsList: [Friend]) {
//        self.friendsList = friendsList
//    }
    
    // Go to detail of place when tapped pin callout
    func goToPlaceDetailView(for id: String, in friendID: String) {
        guard let place = filteredFriends.findPlace(with: id, in: friendID) else {
            print("failed guard check")
            return
        }
        placeDetailPlace = place
        goToPlaceDetail = true
    }
    
    func getDistance(lat: Double, lng: Double) -> String {
        let distanceInMeters = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude).distance(from: CLLocation(latitude: lat, longitude: lng))
        print(String(distanceInMeters))
        if distanceInMeters < 1000 {
            return String("\(Int(distanceInMeters)) m")
        } else {
            let km = (distanceInMeters.rounded() / 1000)
            return "\(km) km"
        }
    }
    
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
                self.newPlace.PMData = PlaceMarkAddress(name: placemark.name,
                                                        thoroughfare: placemark.thoroughfare,
                                                        subThoroughfare: placemark.subThoroughfare,
                                                        postalCode: placemark.postalCode,
                                                        subLocality: placemark.subLocality,
                                                        administrativeArea: placemark.administrativeArea,
                                                        country: placemark.country,
                                                        countryCode: placemark.isoCountryCode ?? "unknown")
                self.newPlace.lat = coordinate.latitude
                self.newPlace.lng = coordinate.longitude
                print(self.newPlace)
                self.goToAddPlace = true
            }
        }
    }
    
    func setupMapWithFilters() {
        if self.recievedFilters.hasEqualFilters(with: currentFilters) {
            print("no update needed")
            return
        } else {
            print("update needed!!")
            currentFilters = recievedFilters
            if recievedFilters.selectedTags.isEmpty && recievedFilters.selectedCountry.isEmpty && recievedFilters.selectedFriends.isEmpty {
                print("resetting filters")
                DispatchQueue.main.async {
                    self.annotations.removeAll()
                    self.mapView.removeAnnotations(self.annotations)
                }
                return
            } else {
                // fetch new filtered places
                _ = FirebaseRepository.getFilteredPlaces(filteredList: recievedFilters, friendsList: friendsList)
                    .sink { error in
                        print("Error getting places: \(error)")
                    } receiveValue: { filteredFriendArray in
                        self.filteredFriends = filteredFriendArray
                        
                        print("Friends for annotations fetched: \(self.filteredFriends)")
                        // place on map
                        for friend in self.filteredFriends {
                            self.produceAnnotationsFromFilter(friend: friend)
                        }
                    }
                
                
                FirebaseRepository.getFilteredPlaces(filteredList: recievedFilters, friendsList: friendsList) { (result) in
                    switch result {
                    case .failure(let error):
                        print("Error getting places: \(error)")
                    case.success(let filteredFriendArray):
                        self.filteredFriends = filteredFriendArray
                    }
                    print("Friends for annotations fetched: \(self.filteredFriends)")
                    // place on map
                    for friend in self.filteredFriends {
                        self.produceAnnotationsFromFilter(friend: friend)
                    }
                }
            }
            
        }
        // Move map to location
        guard let centerCoordinate = CenterLocations().countryCenterCoordinates[recievedFilters.selectedCountry] else { return }
        let coordinateRegion = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    private func produceAnnotationsFromFilter(friend: Friend) {
        DispatchQueue.main.async {
            self.annotations.removeAll()
            self.mapView.removeAnnotations(self.annotations)
        }
        
        for place in friend.info.places {
            let pointAnnotation = PlaceAnnotation(title: place.title,
                                                  coordinate: place.coordinate,
                                                  info: place.description,
                                                  id: place.uid,
                                                  friendID: friend.info.uid)
//            let pointAnnotation = MKPointAnnotation()
//            pointAnnotation.coordinate = place.coordinate
//            pointAnnotation.title = place.title
//            pointAnnotation.info = place.description
//            pointAnnotation.id = place.uid
            DispatchQueue.main.async {
                self.annotations.append(pointAnnotation)
                self.mapView.addAnnotation(pointAnnotation)
                print("Added annotation")
            }
            
        }
        
    }
    
    func convertCoordinateToAddress(location: CLLocationCoordinate2D, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> ()) {
        let geoCoder = CLGeocoder()
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geoCoder.reverseGeocodeLocation(clLocation) { (placemark, error) -> Void in
            if (error != nil) {
                print("!!! reverse geocode failed: \(String(describing: error?.localizedDescription))")
            }
            guard let placemark = placemark, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
            // MARK: - So it seems you need to either switch to Google Maps or use API from google maps (Places SDK) on the coordinate to get the business name and all other good stuff...
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
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        
        self.mapView.setRegion(self.region, animated: true)
        
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
}
