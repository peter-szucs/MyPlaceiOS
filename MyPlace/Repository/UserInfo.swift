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
    @Published var user = User(uid: "", firstName: "", lastName: "", userName: "", hasFinishedOnboarding: false)
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    func configureFirebaseStateDidChange() {
        if authStateDidChangeListenerHandle == nil {
            authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
                guard let user = user else {
                    self.isUserAuthenticated = .signedOut
                    return
                }
                print("Guardcheck user passed")
                FirebaseRepository.retrieveUser(uid: user.uid) { (result) in
                    print("Retrieve user tried")
                    switch result {
                    case .failure(let error):
                        print("UserInfo: Error retrieving user:", error)
                        self.isUserAuthenticated = .onBoarding
                        return
                    case .success(let userInfo):
                        self.user = userInfo
                        print("UI user.uid: ", user.uid)
                        self.user.uid = user.uid
                        self.isUserAuthenticated = .signedIn
                    }
                }
            })
        }
        
        // MARK: - Think of resolution for onboarding (removing handle here doesn't automatically take you to mapview after succesful first step)
//        Auth.auth().removeStateDidChangeListener(authStateDidChangeListenerHandle)
        print(isUserAuthenticated)
    }
    
    enum FIRAuthState {
        case undefined, signedOut, signedIn, onBoarding
    }
}
