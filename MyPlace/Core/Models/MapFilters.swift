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
    var selectedCountries: [String]
    
    init() {
        self.selectedFriends = []
        self.selectedTags = []
        self.selectedCountries = []
    }
    
    init(selectedFriends: [Friend], selectedTags: [Int], selectedCountries: [String]) {
        self.selectedFriends = selectedFriends
        self.selectedTags = selectedTags
        self.selectedCountries = selectedCountries
    }
}
