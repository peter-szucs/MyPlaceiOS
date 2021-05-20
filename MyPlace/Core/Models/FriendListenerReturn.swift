//
//  FriendListenerReturn.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-20.
//

import Foundation

struct FriendListenerReturn {
    var uid: String
    var status: String
    var changeType: ChangeType
    
    init() {
        self.uid = ""
        self.status = ""
        self.changeType = .added
    }
    
    init(uid: String, status: String, changeType: ChangeType) {
        self.uid = uid
        self.status = status
        self.changeType = changeType
    }
    
    enum ChangeType: Int {
        
        case added
        case modified
        case removed
    }
}
