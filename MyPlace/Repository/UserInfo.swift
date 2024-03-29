//
//  UserInfo.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import SwiftUI
import FirebaseAuth
import CoreLocation
import Combine

// debug/trials
import FirebaseFirestore

class UserInfo: ObservableObject {
    
    @ObservedObject var monitor = NetworkMonitor()
    
    @Published var isUserAuthenticated: FIRAuthState = .undefined {
        didSet {
            if isUserAuthenticated == .signedIn {
                print("!!! user signed in")
                setFriendListener()
            }
        }
    }
    @Published var user = User()
    @Published var userLocation = CLLocationCoordinate2D()
    
    @Published var fullFriendsList: [Friend] = []
    @Published var friendsList: [Friend] = []
    @Published var sentRequestList: [Friend] = []
    @Published var recievedRequestList: [Friend] = []
    
    @Published var currentMapFilters: MapFilters = MapFilters() {
        didSet {
            print("!!! userInfo filters didSet")
        }
    }
    
    var cancellable: AnyCancellable?
    
    var lruUserImageCache: LRUCache<String, Image> = LRUCache(capacity: 1)
    var lruFriendsImagesCache: LRUCache<String, Image> = LRUCache(capacity: 50)
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    private var cancellables = Set<AnyCancellable>()
    
    func initialSetup() {
        
        // debug/trials
        debugAndTrialsFunction()
        // ------------
        
        configureFirebaseStateDidChange { (authState) in
            if authState == .signedIn {
                self.fetchFriends { (result) in
                    if !result {
                        print("Friends and friendrequests not fetched. Or user doesn't have any")
                    }
                    DispatchQueue.main.async {
                        self.isUserAuthenticated = authState
                    }
                    DispatchQueue.global().async {
                        self.cacheProfileImages()
                    }
//                    self.setFriendListener()
                }
            } else {
                self.isUserAuthenticated = authState
            }
            print(self.isUserAuthenticated)
        }
    }
    
    // MARK: - ###### DEBUG #######
    
    private func debugAndTrialsFunction() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
//        var ref = Firestore.firestore().collection("users").document(uid).collection("places").whereField("pmData.countryCode", isEqualTo: "DE")
        var ref: Query?
        
        // first one must initialize path as well, depending on if multiple countries or not ->
        // multiple countries:
        ref = Firestore.firestore().collection("users").document(uid).collection("places").whereField("pmData.countryCode", isEqualTo: "")
        // one country
//        ref = Firestore.firestore().collection("users").document(uid).collection("places").whereField("pmData.countryCode", isEqualTo: "DE")
        // chain multiple queries for filter
//        ref = ref?.whereField("pmData.countryCode", isEqualTo: "SE")
//        ref = ref?.whereField("tags", arrayContainsAny: [0, 1, 2])
        var places: [Place] = []
        ref?.getDocuments { (snap, err) in
            if let err = err {
                print("error: \(err)")
            } else {
                guard let documents = snap?.documents else {
                    print("failed guard")
                    return
                }
                for document in documents {
                    let p = Place(documentData: document.data(), id: document.documentID)!
                    places.append(p)
                    print("### QUERY returns: \(p) ###")
                }
            }
        }
    }
    // MARK: _ ###### END DEBUG ########
    
    var authStatusPublisher: AnyPublisher<Bool, Never> {
        $isUserAuthenticated
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map {
                if $0 == .signedIn { return true }
                return false
            }
            .eraseToAnyPublisher()
        
//        $newUserObject
//            .debounce(for: 0.5, scheduler: RunLoop.main)
//            .map {
//                if $0.firstName != self.originalUserObject.firstName { return true }
//                if $0.lastName != self.originalUserObject.lastName { return true }
//                if $0.userName != self.originalUserObject.userName { return true }
//                return false
//            }
//            .eraseToAnyPublisher()
    }
    
    // MARK: - Image Caching of Friends and User profile image.
    private func cacheProfileImages() {
        if !user.uid.isEmpty {
            let path = FIRKeys.StoragePath.profileImages+"/\(user.uid)"
            FirebaseRepository.getFromStorage(path: path) { (result) in
                switch result {
                case .failure(let error):
                    print("Failure retrieving users profileImage: \(error)")
                case .success(let image):
                    self.lruUserImageCache.setObject(for: self.user.uid, value: image)
                    print("added user profile image to cache.")
                }
            }
            DispatchQueue.global().async {
                for friend in self.user.friends {
                    print("friend: \(friend)")
                    let path = FIRKeys.StoragePath.profileImages+"/\(friend.info.uid)"
                    FirebaseRepository.getFromStorage(path: path) { (result) in
                        switch result {
                        case .failure(let error):
                            print("error fetching \(friend.info.userName): \(error)")
                        case .success(let image):
                            self.lruFriendsImagesCache.setObject(for: friend.info.uid, value: image)
                            print("added friend \(friend.info.userName) profile image to cache.")
                        }
                    }
                }
            }
        }
        
    }
    
    private func fetchFriends(completion: @escaping (Bool) -> ()) {
        cancellable = FirebaseRepository.retrieveFriends(uid: user.uid)
            .receive(on: RunLoop.main)
            .sink { error in
                print("##func fetchFriends - error retrieveing documents: \(error)")
                completion(false)
            } receiveValue: { friendsArray in
                print("##func fetchFriends - Recieving value on sink")
                DispatchQueue.main.async {
                    self.fullFriendsList = friendsArray
                    self.user.friends = friendsArray
                    self.makeLists()
                    completion(true)
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
        print("Friend listener initiated")
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
                                FirebaseRepository.getFromStorage(path: FIRKeys.StoragePath.profileImages+"/\(user.uid)") { (result) in
                                    switch result {
                                    case .failure(let error):
                                        print("failed to retrieve user image: \(error)")
                                        self.recievedRequestList.append(Friend(info: user, status: newFriend.status))
                                    case .success(let image):
                                        self.lruFriendsImagesCache.setObject(for: user.uid, value: image)
                                        self.recievedRequestList.append(Friend(info: user, status: newFriend.status))
                                    }
                                }
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
