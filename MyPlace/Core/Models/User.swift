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
    
    init(uid: String, firstName: String, lastName: String, userName: String) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
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
                  userName: userName)
    }
        
    static func dataDict(uid: String, firstName: String, lastName: String, userName: String) -> [String : Any] {
        var data: [String: Any]
        
        if firstName != "" {
            data = [FIRKeys.User.uid: uid,
                    FIRKeys.User.firstName: firstName,
                    FIRKeys.User.lastName: lastName,
                    FIRKeys.User.userName: userName]
        } else {
            data = [FIRKeys.User.uid: uid]
        }
        return data
    }
    
}

