//
//  FriendDetailViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-18.
//

import SwiftUI

final class FriendDetailViewModel: ObservableObject {
    
    @Published var friend: Friend
    @Published var places: [Place] = []
    @Published var isLoading = false
    
    init(friend: Friend) {
        self.friend = friend
        fetchPlaces()
    }
    
    private func fetchPlaces() {
        isLoading = true
        FirebaseRepository.getPlaceDocuments(for: friend.info.uid) { (result) in
            switch result {
            case .failure(let error):
                print("Failure to get documents: \(error)")
                self.isLoading = false
            case .success(let fetchedPlaces):
                DispatchQueue.main.async {
                    self.places = fetchedPlaces
                    self.isLoading = false
                }
            }
        }
    }
}
