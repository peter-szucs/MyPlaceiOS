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
    var creationDate: Date
    var lat: Double
    var lng: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
//    private var images: [Image]?
    
    init(uid: String, title: String, description: String, creationDate: Date, lat: Double, lng: Double) {
        self.uid = uid
        self.title = title
        self.description = description
        self.creationDate = creationDate
        self.lat = lat
        self.lng = lng
    }
    
    // Firebase Init
    init?(documentData: [String: Any]) {
        let uid = documentData[FIRKeys.Place.uid] as? String ?? ""
        let title = documentData[FIRKeys.Place.title] as? String ?? ""
        let description = documentData[FIRKeys.Place.description] as? String ?? ""
        // MARK: TODO: Date conversion here (Timestamp -> Date). Remove creationDate from upload/struct ? (documentSnapshot.get("created_at") as! Timestamp)
        let creationDate = documentData[FIRKeys.Place.creationDate] as? Date ?? Date()
        let lat = documentData[FIRKeys.Place.latitude] as? Double ?? 0.0
        let lng = documentData[FIRKeys.Place.longitude] as? Double ?? 0.0
        
        
        self.init(uid: uid,
                  title: title,
                  description: description,
                  creationDate: creationDate,
                  lat: lat,
                  lng: lng)
    }
    
    static func dataDict(title: String, description: String, creationDate: Date, lat: Double, lng: Double) -> [String : Any] {
        var data: [String: Any]
       
        data = [FIRKeys.Place.title: title,
                FIRKeys.Place.description: description,
                FIRKeys.Place.creationDate: creationDate,
                FIRKeys.Place.latitude: lat,
                FIRKeys.Place.longitude: lng]
        
        return data
    }
    
}
