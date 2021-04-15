//
//  Place.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-04-14.
//

import SwiftUI

final class Place {
    private var title: String
    private var description: String
    private var creationDate: Date
    private var lat: Double
    private var lng: Double
    private var images: [Image]?
    
    init(title: String, description: String, creationDate: Date, lat: Double, lng: Double, images: [Image]?) {
        self.title = title
        self.description = description
        self.creationDate = creationDate
        self.lat = lat
        self.lng = lng
        self.images = images ?? nil
    }
    
}
