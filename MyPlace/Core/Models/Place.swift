//
//  Place.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-04-14.
//

import FirebaseFirestore
import SwiftUI

struct Place: Identifiable, Codable {
    var id: String
    private var title: String
    private var description: String
    private var creationDate: Date
    private var lat: Double
    private var lng: Double
//    private var images: [Image]?
    
    init(id: String,
         title: String,
         description: String,
         creationDate: Date,
         lat: Double,
         lng: Double)
//         images: [Image]?)
    {
        self.id = id
        self.title = title
        self.description = description
        self.creationDate = creationDate
        self.lat = lat
        self.lng = lng
//        self.images = images ?? nil
    }
    
}
