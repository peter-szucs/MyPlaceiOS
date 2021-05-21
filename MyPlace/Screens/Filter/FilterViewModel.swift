//
//  FilterViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-20.
//

import SwiftUI

final class FilterViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var tabTitles: [LocalizedStringKey] = ["Menu_friends", "AddPlace_tags", "Filter_country"]
    @Published var tabSelection: Int = 0
    @Published var equalWidth: CGFloat = 0
    
    @Published var friendsSelected: [Friend] = []
    @Published var tagsSelected: [Int] = []
    @Published var countriesSelected: [String] = []
    
    @Published var tagsList: [Tag] = []
    
    @Published var isEditing = false
    @Published var searchString: String = ""
    
    init() {
        equalWidth = UIScreen.main.bounds.width / CGFloat(tabTitles.count)
        makeTaglist()
    }
    
    func isFriendSelected(friend: Friend) -> Bool {
        for i in 0..<friendsSelected.count {
            if friendsSelected[i].info.uid == friend.info.uid {
                return true
            }
        }
        return false
    }
    
    func isCountrySelected(countryCode: String) -> Bool {
        for i in 0..<countriesSelected.count {
            if countriesSelected[i] == countryCode {
                return true
            }
        }
        return false
    }
    
    func isAllFiltersEmpty() -> Bool {
        return friendsSelected.isEmpty && tagsSelected.isEmpty && countriesSelected.isEmpty
    }
    
    func addFriendToFilter(friend: Friend) {
        if isFriendSelected(friend: friend) {
            removeFriendFromList(friend: friend)
        } else {
            self.friendsSelected.append(friend)
        }
    }
    
    func addCountryToFilter(countryCode: String) {
        if isCountrySelected(countryCode: countryCode) {
            removeCountryFromList(countryCode: countryCode)
        } else {
            self.countriesSelected.append(countryCode)
        }
    }
    
    func countryFlag(countryCode: String) -> String {
        return String(String.UnicodeScalarView(countryCode.unicodeScalars.compactMap(
                                                { UnicodeScalar(127397 + $0.value) })))
    }
    
    func clearAllFilters() {
        friendsSelected.removeAll()
        tagsSelected.removeAll()
        countriesSelected.removeAll()
    }
    
    private func makeTaglist() {
        var returnList: [Tag] = []
        for i in Tags.allCases {
            returnList.append(Tag(typeValue: i.rawValue))
        }
        self.tagsList = returnList
    }
    
    private func removeFriendFromList(friend: Friend) {
        print("selected friends: \(friendsSelected)")
        for i in 0..<friendsSelected.count {
            print("index: \(i), friend: \(friend)")
            if friendsSelected[i].info.uid == friend.info.uid {
                print("friend is here, removing")
                friendsSelected.remove(at: i)
                return
            }
        }
    }
    
    private func removeCountryFromList(countryCode: String) {
        for i in 0..<countriesSelected.count {
            if countriesSelected[i] == countryCode {
                countriesSelected.remove(at: i)
                return
            }
        }
    }
}
