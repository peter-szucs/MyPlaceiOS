//
//  FIRKeys.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import Foundation

enum FIRKeys {
    
    enum CollectionPath {
        static let users = "users"
        static let places = "places"
    }
    
    enum StoragePath {
        static let profileImages = "profileImages"
        static let placeImages = "placeImages"
    }
    
    enum User {
        static let uid = "uid"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let userName = "userName"
        static let hasFinishedOnboarding = "hasFinishedOnboarding"
    }
    
    enum Place {
        static let title = "title"
        static let description = "description"
        static let imageIDs = "imageIDs"
        static let pmData = "pmData"
        static let tags = "tags"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    enum Address {
        static let name = "name"
        static let thoroughfare = "thoroughfare"
        static let subThoroughfare = "subThoroughfare"
        static let postalCode = "postalCode"
        static let subLocality = "subLocality"
        static let administrativeArea = "administrativeArea"
        static let country = "country"
    }
}
