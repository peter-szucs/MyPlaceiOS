//
//  FriendsListViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-07.
//

import SwiftUI

final class FriendsListViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    
    @Published var friendsList: [Friend] = []
    @Published var sentRequestList: [Friend] = []
    @Published var recievedRequestList: [Friend] = []
    
    @Published var allLists: [[Friend]] = []
    
    @Published var tabSelection = 0
    
    @Published var friendSearchList: [User] = []
    @Published var friendSearchString: String = ""
    @Published var addFriend: Bool = false
    @Published var friendSearchResultText: String = ""
    
    @Published var showingActionSheet = false
    @Published var isFriendListLoading = false
    
    @Published var tabTitles = [LocalizedStringKey("FriendList_tab01"),
                                LocalizedStringKey("FriendList_tab02"),
                                LocalizedStringKey("FriendList_tab03")]
    
    @Published var equalWidth: CGFloat = 0
    
    var lruFriendsImageCache: LRUCache<String, Image>
    
    init(cache: LRUCache<String, Image>) {
        self.lruFriendsImageCache = cache
        equalWidth = UIScreen.main.bounds.width / CGFloat(tabTitles.count)
    }
    
    func loadImage(id: String) -> Image? {
        if let avatarImage = lruFriendsImageCache.retrieveObject(at: id) {
            print("!!! ## is in Cache")
            return avatarImage
        } else {
            print("!!! ## is not in cache, retrieving")
            var returnImage: Image?
            FirebaseRepository.getFromStorage(path: FIRKeys.StoragePath.profileImages+"/\(id)") { (result) in
                switch result {
                case .failure(let error):
                    print("failed to fetch user image: \(error)")
                    returnImage = Image(systemName: "person.circle.fill")
                case .success(let image):
                    self.lruFriendsImageCache.setObject(for: id, value: image)
                    print("!!! ## Cached friends Image")
                    returnImage = image
                }
            }
            return returnImage
        }
    }
    
    func performFriendSearch() {
        isFriendListLoading = true
        FirebaseRepository.searchForFriend(userName: friendSearchString) { (result) in
            switch result {
            case .failure(let error):
                print("No users found: \(error)")
                self.friendSearchResultText = "No users found with the username \(self.friendSearchString)"
                self.isFriendListLoading = false
            case .success(let users):
                self.getAndCacheSearchedFriendImages(users: users) { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.friendSearchList.removeAll()
                            self.friendSearchList = users
                            self.isFriendListLoading = false
                        }
                    }
                }
                
            }
        }
    }
    
    private func getAndCacheSearchedFriendImages(users: [User], completion: @escaping (Bool) -> ()) {
        let dispatch = DispatchGroup()
        for user in users {
            dispatch.enter()
            FirebaseRepository.getFromStorage(path: FIRKeys.StoragePath.profileImages+"/\(user.uid)") { (result) in
                switch result {
                case .failure(let error):
                    print("error fetching image for user : \(user), \(error)")
                    completion(true)
                case .success(let image):
                    self.lruFriendsImageCache.setObject(for: user.uid, value: image)
                    dispatch.leave()
                }
            }
        }
        dispatch.notify(queue: .global()) {
            // MARK: TODO: in future, maybe add image to friends "avatarImage" instead. Or make a good global imageloader.
            completion(true)
        }
    }
    
    func sendFriendRequest(uid: String, friend: User, completion:@escaping (Bool) -> ()) {
        FirebaseRepository.makeFriendRequest(uid: uid, friendID: friend.uid, completion: { (result) in
            if result {
                DispatchQueue.main.async {
//                    self.sentRequestList.append(Friend(info: friend, status: "sent"))
//                    self.allLists[1] = self.sentRequestList
//                    print("!!! sentList: \(self.sentRequestList), allList: \(self.allLists)")
                }
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    func handleFriendRequest(uid: String, friend: Friend, accept: Bool, completion: @escaping (Bool) -> ()) {
        if accept {
            FirebaseRepository.updateFriendRequests(status: "accepted", uid: uid, friendStatus: "accepted", friendID: friend.info.uid) { (result) in
                if result {
                    DispatchQueue.main.async {
//                        self.removeFromList(list: "recievedRequestList", friendID: friend.info.uid)
                        var newFriend = friend
                        newFriend.status = "accepted"
//                        self.friendsList.append(newFriend)
                    }
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } else {
            FirebaseRepository.denyFriendRequest(uid: uid, friendID: friend.info.uid)
            completion(true)
//            self.removeFromList(list: "recievedRequestList", friendID: friend.info.uid)
        }
        
    }
    
//    private func removeFromList(list: String, friendID: String) {
//        switch list {
//        case "sentRequestList":
//            for i in 0..<sentRequestList.count {
//                if sentRequestList[i].info.uid == friendID {
//                    sentRequestList.remove(at: i)
//                    print("removefromList: \(sentRequestList)")
//                }
//            }
//        case "recievedRequestList":
//            print(recievedRequestList.count)
//            for i in 0..<recievedRequestList.count {
//                if recievedRequestList[i].info.uid == friendID {
//                    recievedRequestList.remove(at: i)
//                    print("removefromList: \(recievedRequestList)")
//                }
//            }
//        default:
//            print("This shouldn't happen")
//        }
//    }
}
