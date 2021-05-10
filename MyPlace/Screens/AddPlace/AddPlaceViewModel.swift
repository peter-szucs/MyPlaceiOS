//
//  AddPlaceViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-09.
//

import Foundation

final class AddPlaceViewModel: ObservableObject {
    
    @Published var place = Place(uid: "", title: "", description: "", tags: [], lat: 0, lng: 0)
    @Published var showingSheet = false
}
