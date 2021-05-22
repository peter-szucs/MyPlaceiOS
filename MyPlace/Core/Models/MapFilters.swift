//
//  MapFilters.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-21.
//

import Foundation

struct MapFilters {
    var selectedFriends: [Friend]
    var selectedTags: [Int]
    var selectedCountry: String
    
    init() {
        self.selectedFriends = []
        self.selectedTags = []
        self.selectedCountry = ""
    }
    
    init(selectedFriends: [Friend], selectedTags: [Int], selectedCountry: String) {
        self.selectedFriends = selectedFriends
        self.selectedTags = selectedTags
        self.selectedCountry = selectedCountry
    }
    
    func hasEqualFilters(with otherFilters: MapFilters) -> Bool {
        let thisFilter = self
        if thisFilter.selectedFriends.containsSameFriends(as: otherFilters.selectedFriends) &&
            thisFilter.selectedCountry == otherFilters.selectedCountry &&
            thisFilter.selectedTags.containsSameElements(as: otherFilters.selectedTags) {
            return true
        } else {
            return false
        }
    }
}
