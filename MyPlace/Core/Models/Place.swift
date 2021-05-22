//
//  Place.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-04-14.
//

import SwiftUI
import MapKit

struct Place {
    var uid: String
    var title: String
    var description: String
    var imageIDs: [String]
    var images: [Image]?
//    var creationDate: Date
    var PMData: PlaceMarkAddress
    var tagIds: [Int]
    var tags: [Tag] {
        var array: [Tag] = []
        for i in tagIds {
            array.append(Tag(typeValue: i))
        }
        return array
    }
    var lat: Double
    var lng: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    init() {
        self.uid = ""
        self.title = ""
        self.description = ""
        self.imageIDs = []
        self.PMData = PlaceMarkAddress()
        self.tagIds = []
        self.lat = 0
        self.lng = 0
    }
    
    init(uid: String, title: String, description: String, imageIDs: [String], PMData: PlaceMarkAddress, tagIds: [Int], lat: Double, lng: Double) {
        self.uid = uid
        self.title = title
        self.description = description
        self.imageIDs = imageIDs
        self.PMData = PMData
        self.tagIds = tagIds
        self.lat = lat
        self.lng = lng
    }
    
    // Firebase Init
    init?(documentData: [String: Any], id: String) {
        let uid = id
        let title = documentData[FIRKeys.Place.title] as? String ?? ""
        let description = documentData[FIRKeys.Place.description] as? String ?? ""
        let imageIDs = documentData[FIRKeys.Place.imageIDs] as? [String] ?? []
        
        // MARK: TODO: Date conversion here (Timestamp -> Date). Remove creationDate from upload/struct ?
        // let settings = Firestore.firestore().settings
        // setting.areTimestampsInSnapshotEnabled = true
        // db.settings = settings
        // (documentSnapshot.get("created_at") as! Timestamp)
        // let date: Date = timestamp.dateValue()
        
        let PMData = documentData[FIRKeys.Place.pmData] as? [String : Any]
        let tagIds = documentData[FIRKeys.Place.tags] as? [Int] ?? []
        let lat = documentData[FIRKeys.Place.latitude] as? Double ?? 0.0
        let lng = documentData[FIRKeys.Place.longitude] as? Double ?? 0.0
        
        self.uid = uid
        self.title = title
        self.description = description
        self.imageIDs = imageIDs
        self.PMData = PlaceMarkAddress(documentData: PMData) ?? PlaceMarkAddress()
        self.tagIds = tagIds
        self.lat = lat
        self.lng = lng
        
    }
    
    static func dataDict(title: String, description: String, imageIDs: [String], pmData: PlaceMarkAddress, tags: [Int], lat: Double, lng: Double) -> [String : Any] {
        var data: [String: Any]
       
        data = [FIRKeys.Place.title: title,
                FIRKeys.Place.description: description,
                FIRKeys.Place.imageIDs: imageIDs,
                FIRKeys.Place.pmData: PlaceMarkAddress.dataDict(placemarkAddress: pmData),
                FIRKeys.Place.tags: tags,
                FIRKeys.Place.latitude: lat,
                FIRKeys.Place.longitude: lng]
        
        return data
    }
    
    static func dataDict(place: Place) -> [String: Any] {
        var data: [String: Any]
       
        data = [FIRKeys.Place.title: place.title,
                FIRKeys.Place.description: place.description,
                FIRKeys.Place.imageIDs: place.imageIDs,
                FIRKeys.Place.pmData: PlaceMarkAddress.dataDict(placemarkAddress: place.PMData),
                FIRKeys.Place.tags: place.tagIds,
                FIRKeys.Place.latitude: place.lat,
                FIRKeys.Place.longitude: place.lng]
        
        return data
    }
    
    func getDistance(placeLat: Double, placeLng: Double, userLat: Double, userLng: Double) -> String {
        let distanceInMeters = CLLocation(latitude: userLat, longitude: userLng).distance(from: CLLocation(latitude: placeLat, longitude: placeLng))
        print(String(distanceInMeters))
        if distanceInMeters < 1000 {
            return String("\(Int(distanceInMeters)) m")
        } else {
            let km = (distanceInMeters.rounded() / 1000)
            return "\(km) km"
        }
    }
    
    func isIn(listOfPlaces: [Place]) -> Bool {
        let thisPlace = self
        for place in listOfPlaces {
            if place.uid == thisPlace.uid {
                return true
            }
        }
        return false
    }
}
