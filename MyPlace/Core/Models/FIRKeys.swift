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
    }
    
    enum User {
        static let uid = "uid"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let userName = "userName"
        static let hasFinishedOnboarding = "hasFinishedOnboarding"
    }
}
