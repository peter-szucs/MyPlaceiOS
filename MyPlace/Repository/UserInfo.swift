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
    @Published var user = User(uid: "", firstName: "", lastName: "", userName: "")
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    func configureFirebaseStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            guard let _ = user else {
                self.isUserAuthenticated = .signedOut
                return
            }
            self.isUserAuthenticated = .signedIn
        })
        // MARK: - Think of resolution for onboarding (removing handle here doesn't automatically take you to mapview after succesful first step)
//        Auth.auth().removeStateDidChangeListener(authStateDidChangeListenerHandle)
    }
    
    enum FIRAuthState {
        case undefined, signedOut, signedIn
    }
}
