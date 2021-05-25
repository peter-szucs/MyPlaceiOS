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
}

extension Array where Element == Friend {
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
}
