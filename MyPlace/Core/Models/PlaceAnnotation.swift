//
//  PlaceAnnotation.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-24.
//

import UIKit
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var id: String
    var friendID: String

    init(title: String, coordinate: CLLocationCoordinate2D, info: String, id: String, friendID: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.id = id
        self.friendID = friendID
    }
}

