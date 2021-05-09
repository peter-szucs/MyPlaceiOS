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
    var hasFinishedOnboarding: Bool
    
    init(uid: String, firstName: String, lastName: String, userName: String, hasFinishedOnboarding: Bool) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
        self.hasFinishedOnboarding = hasFinishedOnboarding
    }
    
    // Firebase Init
    init?(documentData: [String: Any]) {
        let uid = documentData[FIRKeys.User.uid] as? String ?? ""
        let firstName = documentData[FIRKeys.User.firstName] as? String ?? ""
        let lastName = documentData[FIRKeys.User.lastName] as? String ?? ""
        let userName = documentData[FIRKeys.User.userName] as? String ?? ""
        let hasFinishedOnboarding = documentData[FIRKeys.User.hasFinishedOnboarding] as? Bool ?? false
        
        self.init(uid: uid,
                  firstName: firstName,
                  lastName: lastName,
                  userName: userName,
                  hasFinishedOnboarding: hasFinishedOnboarding)
    }
        
    static func dataDict(firstName: String, lastName: String, userName: String, hasFinishedOnboarding: Bool) -> [String : Any] {
        var data: [String: Any]
       
        data = [FIRKeys.User.firstName: firstName,
                FIRKeys.User.lastName: lastName,
                FIRKeys.User.userName: userName,
                FIRKeys.User.hasFinishedOnboarding: hasFinishedOnboarding]
        
        return data
    }
    
    static func dataDict(user: User) -> [String : Any] {
        var data: [String: Any]
       
        data = [FIRKeys.User.firstName: user.firstName,
                FIRKeys.User.lastName: user.lastName,
                FIRKeys.User.userName: user.userName,
                FIRKeys.User.hasFinishedOnboarding: user.hasFinishedOnboarding]
        
        return data
    }
    
}

