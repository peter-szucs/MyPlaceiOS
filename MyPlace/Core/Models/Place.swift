//
//  Place.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-04-14.
//

import Foundation
import MapKit

struct Place {
    var uid: String
    var title: String
    var description: String
//    var creationDate: Date
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
//    private var images: [Image]?
    
    init(uid: String, title: String, description: String, tagIds: [Int], lat: Double, lng: Double) {
        self.uid = uid
        self.title = title
        self.description = description
        self.tagIds = tagIds
        self.lat = lat
        self.lng = lng
    }
    
    // Firebase Init
    init?(documentData: [String: Any], id: String) {
        let uid = id
        let title = documentData[FIRKeys.Place.title] as? String ?? ""
        let description = documentData[FIRKeys.Place.description] as? String ?? ""
        // MARK: TODO: Date conversion here (Timestamp -> Date). Remove creationDate from upload/struct ?
        // let settings = Firestore.firestore().settings
        // setting.areTimestampsInSnapshotEnabled = true
        // db.settings = settings
        // (documentSnapshot.get("created_at") as! Timestamp)
        // let date: Date = timestamp.dateValue()
        
        let tagIds = documentData[FIRKeys.Place.tags] as? [Int] ?? []
        let lat = documentData[FIRKeys.Place.latitude] as? Double ?? 0.0
        let lng = documentData[FIRKeys.Place.longitude] as? Double ?? 0.0
        
        self.uid = uid
        self.title = title
        self.description = description
        self.tagIds = tagIds
        self.lat = lat
        self.lng = lng
        
//        self.init(uid: uid,
//                  title: title,
//                  description: description,
//                  tags: tags,
//                  lat: lat,
//                  lng: lng)
    }
    
    static func dataDict(title: String, description: String, tags: [Int], lat: Double, lng: Double) -> [String : Any] {
        var data: [String: Any]
       
        data = [FIRKeys.Place.title: title,
                FIRKeys.Place.description: description,
                FIRKeys.Place.tags: tags,
                FIRKeys.Place.latitude: lat,
                FIRKeys.Place.longitude: lng]
        
        return data
    }
    
    static func dataDict(place: Place) -> [String: Any] {
        var data: [String: Any]
       
        data = [FIRKeys.Place.title: place.title,
                FIRKeys.Place.description: place.description,
                FIRKeys.Place.tags: place.tagIds,
                FIRKeys.Place.latitude: place.lat,
                FIRKeys.Place.longitude: place.lng]
        
        return data
    }
    
}
