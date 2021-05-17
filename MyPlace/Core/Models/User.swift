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
    
    init() {
        self.uid = ""
        self.firstName = ""
        self.lastName = ""
        self.userName = ""
        self.friends = []
    }
    
    init(uid: String, firstName: String, lastName: String, userName: String, friends: [Friend]) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
        self.friends = friends
    }
    
    // Firebase Init
    init?(documentData: [String: Any]) {
        let uid = documentData[FIRKeys.User.uid] as? String ?? ""
        let firstName = documentData[FIRKeys.User.firstName] as? String ?? ""
        let lastName = documentData[FIRKeys.User.lastName] as? String ?? ""
        let userName = documentData[FIRKeys.User.userName] as? String ?? ""
        
        self.init(uid: uid,
                  firstName: firstName,
                  lastName: lastName,
                  userName: userName,
                  friends: [])
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

