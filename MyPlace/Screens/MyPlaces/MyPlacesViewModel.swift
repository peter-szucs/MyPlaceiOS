//
//  MyPlacesViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-12.
//

import SwiftUI
import CoreLocation

final class MyPlacesViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var places: [Place] = []
    @Published var goToDetailView = false
    @Published var imagesForDetailView: [Image] = []
    
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
//    var user = User(uid: "", firstName: "", lastName: "", userName: "", hasFinishedOnboarding: false)
    
    func fetchData(for uid: String) {
        // MARK: - Check how lifecycle works. so no need to refetch every time. Cache ?
        FirebaseRepository.getPlaceDocuments(for: uid) { (result) in
            switch result {
            case .failure(let error):
                self.isLoading = false
                print("Error fetching documents from collection: \(error)")
            case .success(let fetchedPlaces):
                self.places = fetchedPlaces
                self.isLoading = false
            }
        }
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
}
