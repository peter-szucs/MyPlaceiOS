//
//  UserInfo.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import SwiftUI
import FirebaseAuth
import CoreLocation

class UserInfo: ObservableObject {
    
    @Published var isUserAuthenticated: FIRAuthState = .undefined
    @Published var user = User()
    @Published var userLocation = CLLocationCoordinate2D()
    
    @Published var fullFriendsList: [Friend] = []
    @Published var friendsList: [Friend] = []
    @Published var sentRequestList: [Friend] = []
    @Published var recievedRequestList: [Friend] = []
    
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
                    self.fullFriendsList = friends
                    self.makeLists()
                    completion(true)
                }
            }
        }
    }
    
    private func makeLists() {
        for friend in fullFriendsList {
            // MARK: TODO: Convert to Enum switch
            if friend.status == "accepted" {
                self.friendsList.append(friend)
            } else if friend.status == "sent" {
                self.sentRequestList.append(friend)
            } else {
                self.recievedRequestList.append(friend)
            }
        }
    }
    
    // MARK: - Send back values thrue listener completion.
    // MARK: TODO: Refactor to just use the changeType enum for actions.
    private func setFriendListener() {
        FirebaseRepository.friendCollectionListener(uid: user.uid) { (newFriend) in
            print("!!! userinfo recieved change in: \(newFriend)")
            let isDuplicate = self.checkForDuplicateFriend(friend: newFriend)
            print("!!! friend is duplicate: \(isDuplicate)")
            if !isDuplicate {
                if newFriend.status == "accepted" {
                    print("!!! Not new or added friend")
                    guard let newAcceptedFriend = self.removeFromList(friendID: newFriend.uid) else {
                        print("!!! Error: newFriend returned nil upon removal")
                        return
                    }
                    let friendToAdd = Friend(info: newAcceptedFriend.info, status: "accepted")
                    self.friendsList.append(friendToAdd)
                } else if newFriend.status == "recieved" {
                    if newFriend.changeType != .removed {
                        FirebaseRepository.retrieveUser(uid: newFriend.uid) { (result) in
                            switch result {
                            case .failure(let error):
                                print("Failed fetching user inside friendListener: \(error)")
                            case .success(let user):
                                self.recievedRequestList.append(Friend(info: user, status: newFriend.status))
                            }
                        }
                    }
                }
            } else {
                if newFriend.changeType == .removed {
                    let _ = self.removeFromList(friendID: newFriend.uid)
                }
            }
        }
    }
    
    func newFriendRequestSentFromUser(for friend: Friend) {
        DispatchQueue.main.async {
            self.sentRequestList.append(friend)
        }
    }
    
    func handleFriendRequest(for friend: Friend, accept: Bool) {
        if !accept {
            DispatchQueue.main.async {
                let _ = self.removeFromList(friendID: friend.info.uid)
            }
        }
    }
    
    private func checkForDuplicateFriend(friend: FriendListenerReturn) -> Bool {
        let statuses = ["accepted", "recieved", "sent"]
        let lists = [friendsList, recievedRequestList, sentRequestList]
        for i in 0..<statuses.count {
            if friend.status == statuses[i] {
                for j in 0..<lists[i].count {
                    if lists[i][j].info.uid == friend.uid {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func removeFromList(friendID: String) -> Friend? {
        
        let lists = [recievedRequestList, sentRequestList]
        for i in 0..<lists.count {
            let list = lists[i]
            for j in 0..<list.count {
                if list[j].info.uid == friendID {
                    if i == 0 {
                        print("Removed from recieved list")
                        return recievedRequestList.remove(at: j)
                    } else {
                        print("Removed from sent list")
                        return sentRequestList.remove(at: j)
                    }
                }
            }
        }
        print("!!! This should never be reached")
        return nil
    }
    
    private func configureFirebaseStateDidChange(completion: @escaping (FIRAuthState) -> ()) {
        if authStateDidChangeListenerHandle == nil {
            authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
                guard let user = user else {
                    completion(.signedOut)
                    return
                }
                FirebaseRepository.retrieveUser(uid: user.uid) { (result) in
                    switch result {
                    case .failure(let error):
                        print("UserInfo: Error retrieving user:", error)
                        completion(.onBoarding)
                        return
                    case .success(let userInfo):
                        self.user = userInfo
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
