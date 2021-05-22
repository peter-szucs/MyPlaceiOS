//
//  Friend.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-16.
//

import Foundation

struct Friend {
    
    var info: User
    var status: String
    
    init() {
        self.info = User()
        self.status = "sent"
    }
    
    init(info: User, status: String) {
        self.info = info
        self.status = status
    }
    
    init?(documentData: [String : Any], user: User) {
        let status = documentData["status"] as? String ?? ""
        
        self.init(info: user, status: status)
    }
    
    public func isIn(listOfFriends: [Friend]) -> Bool {
        let thisFriend = self
        for friend in listOfFriends {
            if friend.info.uid == thisFriend.info.uid {
                return true
            }
        }
        return false
    }
}
