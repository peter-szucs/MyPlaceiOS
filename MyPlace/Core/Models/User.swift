//
//  User.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-03-11.
//

import Foundation

struct User {
    var uid: String
    var firstName: String
    var lastName: String
    var userName: String
    var friends: [Friend]
    var places: [Place]
    
    init() {
        self.uid = ""
        self.firstName = ""
        self.lastName = ""
        self.userName = ""
        self.friends = []
        self.places = []
    }
    
    init(uid: String, firstName: String, lastName: String, userName: String, friends: [Friend], places: [Place]) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
        self.friends = friends
        self.places = places
    }
    
    // Firebase Init
    init?(documentData: [String: Any], uid: String) {
        let firstName = documentData[FIRKeys.User.firstName] as? String ?? ""
        let lastName = documentData[FIRKeys.User.lastName] as? String ?? ""
        let userName = documentData[FIRKeys.User.userName] as? String ?? ""
        
        self.init(uid: uid,
                  firstName: firstName,
                  lastName: lastName,
                  userName: userName,
                  friends: [],
                  places: [])
    }
        
    static func dataDict(firstName: String, lastName: String, userName: String) -> [String : Any] {
        var data: [String: Any]
       
        data = [FIRKeys.User.firstName: firstName,
                FIRKeys.User.lastName: lastName,
                FIRKeys.User.userName: userName]
        
        return data
    }
    
    static func dataDict(user: User) -> [String : Any] {
        var data: [String: Any]
       
        data = [FIRKeys.User.firstName: user.firstName,
                FIRKeys.User.lastName: user.lastName,
                FIRKeys.User.userName: user.userName]
        
        return data
    }
    
}

