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
        static let tags = "tags"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
}
