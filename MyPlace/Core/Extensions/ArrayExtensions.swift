//
//  ArrayExtensions.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-17.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}

extension Array where Element == Friend {
    func containsSameFriends(as otherListOfFriends: [Friend]) -> Bool {
        let thisListOfFriends = self
        if thisListOfFriends.count == otherListOfFriends.count {
            for friend in thisListOfFriends {
                if !friend.isIn(listOfFriends: otherListOfFriends) {
                    return false
                }
            }
            return true
        } else {
            return false
        }
        
    }
    
    func findPlace(with placeId: String, in friendID: String) -> Place? {
        for friend in self {
            if friend.info.uid == friendID {
                for place in friend.info.places {
                    if place.uid == placeId {
                        return place
                    }
                }
            }
        }
        return nil
    }
    
    func sortFriendsByUsername() -> [Friend] {
        var returnList = self
        var n = self.count
        while n > 0 {
            var lastModifiedIndex = 0
            for currentIndex in 1..<n {
                // if previous index is larger than currentIndex, swap
                if returnList[currentIndex - 1].info.userName.lowercased() > returnList[currentIndex].info.userName.lowercased() {
                    let temp = returnList[currentIndex - 1]
                    returnList[currentIndex - 1] = returnList[currentIndex]
                    returnList[currentIndex] = temp
                    lastModifiedIndex = currentIndex
                }
            }
            n = lastModifiedIndex
        }
        return returnList
    }
    
    func prettyPrint() {
        var count = 0
        for friend in self {
            if count == 0 {
                print("###############\n")
            }
            print("\(friend.info.firstName), \(friend.info.lastName). \(friend.info.userName)\n")
            count += 1
        }
    }
}

