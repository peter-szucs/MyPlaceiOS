//
//  FriendsListViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-07.
//

import SwiftUI

final class FriendsListViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    
    @Published var fullFriendsList: [Friend]
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
    
    init(friendsList: [Friend]) {
        self.fullFriendsList = friendsList
        makeLists()
        equalWidth = UIScreen.main.bounds.width / CGFloat(tabTitles.count)
        // MARK: - fetch friends
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
        allLists.append(friendsList)
        allLists.append(sentRequestList)
        allLists.append(recievedRequestList)
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
                DispatchQueue.main.async {
                    self.friendSearchList.removeAll()
                    self.friendSearchList = users
                    self.isFriendListLoading = false
                }
            }
        }
    }
    
    func sendFriendRequest(uid: String, friend: User, completion:@escaping (Bool) -> ()) {
        FirebaseRepository.makeFriendRequest(uid: uid, friendID: friend.uid, completion: { (result) in
            if result {
                DispatchQueue.main.async {
                    self.sentRequestList.append(Friend(info: friend, status: "sent"))
                    self.allLists[1] = self.sentRequestList
                    print("!!! sentList: \(self.sentRequestList), allList: \(self.allLists)")
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
                        self.removeFromList(list: "recievedRequestList", friendID: friend.info.uid)
                        var newFriend = friend
                        newFriend.status = "accepted"
                        self.friendsList.append(newFriend)
                    }
                }
            }
        } else {
            FirebaseRepository.denyFriendRequest(uid: uid, friendID: friend.info.uid)
            self.removeFromList(list: "recievedRequestList", friendID: friend.info.uid)
        }
        
    }
    
    private func removeFromList(list: String, friendID: String) {
        switch list {
        case "sentRequestList":
            for i in 0..<sentRequestList.count {
                if sentRequestList[i].info.uid == friendID {
                    sentRequestList.remove(at: i)
                    print("removefromList: \(sentRequestList)")
                }
            }
        case "recievedRequestList":
            print(recievedRequestList.count)
            for i in 0..<recievedRequestList.count {
                if recievedRequestList[i].info.uid == friendID {
                    recievedRequestList.remove(at: i)
                    print("removefromList: \(recievedRequestList)")
                }
            }
        default:
            print("This shouldn't happen")
        }
    }
}
