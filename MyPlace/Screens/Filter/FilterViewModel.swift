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
    
//    @Published var friendsSelected: [Friend]
//    @Published var tagsSelected: [Int]
//    @Published var countriesSelected: [String]
    
    @Published var filters: MapFilters
    @Published var filteredFriends: [Friend] = []
    
    @Published var tagsList: [Tag] = []
    
    @Published var isEditing = false
    @Published var searchString: String = ""
    
    init(filters: MapFilters) {
        self.filters = filters
        equalWidth = UIScreen.main.bounds.width / CGFloat(tabTitles.count)
        makeTaglist()
        
    }
    
    func getFilteredPlaces(friendsList: [Friend], completion: @escaping (Bool) -> ()) {
        FirebaseRepository.getFilteredPlaces(filteredList: filters, friendsList: friendsList) { (result) in
            switch result {
            case .failure(let error):
                print("Error getting places: \(error)")
                completion(false)
            case.success(let filteredFriendArray):
                self.filteredFriends = filteredFriendArray
                completion(true)
            }
        }
    }
    
    func isFriendSelected(friend: Friend) -> Bool {
        for i in 0..<filters.selectedFriends.count {
            if filters.selectedFriends[i].info.uid == friend.info.uid {
                return true
            }
        }
        return false
    }
    
    func isAllFiltersEmpty() -> Bool {
        return filters.selectedFriends.isEmpty && filters.selectedTags.isEmpty && filters.selectedCountry.isEmpty
    }
    
    func addFriendToFilter(friend: Friend) {
        if isFriendSelected(friend: friend) {
            removeFriendFromList(friend: friend)
        } else {
            self.filters.selectedFriends.append(friend)
        }
    }
    
    func addOrRemoveCountryToFilter(countryCode: String) {
        if filters.selectedCountry == countryCode {
            filters.selectedCountry = ""
        } else {
            filters.selectedCountry = countryCode
        }
    }
    
    func countryFlag(countryCode: String) -> String {
        return String(String.UnicodeScalarView(countryCode.unicodeScalars.compactMap(
                                                { UnicodeScalar(127397 + $0.value) })))
    }
    
    func clearAllFilters() {
        filters.selectedFriends.removeAll()
        filters.selectedTags.removeAll()
        filters.selectedCountry = ""
    }
    
    private func makeTaglist() {
        var returnList: [Tag] = []
        for i in Tags.allCases {
            returnList.append(Tag(typeValue: i.rawValue))
        }
        self.tagsList = returnList
    }
    
    private func removeFriendFromList(friend: Friend) {
        for i in 0..<filters.selectedFriends.count {
            print("index: \(i), friend: \(friend)")
            if filters.selectedFriends[i].info.uid == friend.info.uid {
                print("friend is here, removing")
                filters.selectedFriends.remove(at: i)
                return
            }
        }
    }
}
