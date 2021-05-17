//
//  FriendsListViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-07.
//

import SwiftUI

final class FriendsListViewModel: ObservableObject {
    
    @Published var fullFriendsList: [Friend]
    @Published var friendsList: [Friend] = []
    @Published var sentRequestList: [Friend] = []
    @Published var recievedRequestList: [Friend] = []
    @Published var allLists: [[Friend]] = []
    
    init(friendsList: [Friend]) {
        self.fullFriendsList = friendsList
        makeLists()
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
}
