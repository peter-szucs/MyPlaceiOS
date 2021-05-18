//
//  UserInfo.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import Foundation
import FirebaseAuth
import CoreLocation

class UserInfo: ObservableObject {
    
    @Published var isUserAuthenticated: FIRAuthState = .undefined
    @Published var user = User()
    @Published var userLocation = CLLocationCoordinate2D()
    @Published var friendsList: [Friend] = []
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    func initialSetup() {
        configureFirebaseStateDidChange { (authState) in
            if authState == .signedIn {
                self.fetchFriends { (result) in
                    if !result {
                        print("Friends and friendrequests not fetched. Or user doesn't have any")
                    }
                    DispatchQueue.main.async {
                        self.isUserAuthenticated = authState
                    }
                    
                    self.setFriendListener()
                }
                
            } else {
                self.isUserAuthenticated = authState
            }
            print(self.isUserAuthenticated)
        }
    }
    
    private func fetchFriends(completion: @escaping (Bool) -> ()) {
        FirebaseRepository.retrieveFriends(uid: user.uid) { (result) in
            switch result {
            case .failure(let error):
                print("error retrieving documents: \(error)")
                completion(false)
            case .success(let friends):
                DispatchQueue.main.async {
                    self.friendsList = friends
                    
                    completion(true)
                }
            }
        }
    }
    
    // MARK: - Send back values thrue listener completion. Change whole structure to just initialize with the listener for first fetch.
    private func setFriendListener() {
        FirebaseRepository.friendCollectionListener(uid: user.uid)
    }
    
    private func configureFirebaseStateDidChange(completion: @escaping (FIRAuthState) -> ()) {
        if authStateDidChangeListenerHandle == nil {
            authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
                guard let user = user else {
                    completion(.signedOut)
                    return
                }
                print("Guardcheck user passed")
                FirebaseRepository.retrieveUser(uid: user.uid) { (result) in
                    print("Retrieve user tried")
                    switch result {
                    case .failure(let error):
                        print("UserInfo: Error retrieving user:", error)
                        completion(.onBoarding)
                        return
                    case .success(let userInfo):
                        self.user = userInfo
                        print("UI user.uid: ", user.uid)
                        self.user.uid = user.uid
                        completion(.signedIn)
                    }
                }
            })
        }
    }
    
    enum FIRAuthState {
        case undefined, signedOut, signedIn, onBoarding
    }
}
