//
//  UserInfo.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import Foundation
import FirebaseAuth

class UserInfo: ObservableObject {
    
    @Published var isUserAuthenticated: FIRAuthState = .undefined
//    @Published var user = FIRUser(uid: "", firstName: "", lastName: "", userName: "")
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    func configureFirebaseStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (_, user) in
            guard let _ = user else {
                self.isUserAuthenticated = .signedOut
                return
            }
            self.isUserAuthenticated = .signedIn
        })
    }
    
    enum FIRAuthState {
        case undefined, signedOut, signedIn
    }
}
