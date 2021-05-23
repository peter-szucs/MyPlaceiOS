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
    
    var lruFriendsImageCache: LRUCache<String, Image>
    
    init(friend: Friend, cache: LRUCache<String, Image>) {
        self.friend = friend
        self.lruFriendsImageCache = cache
        fetchPlaces()
    }
    
    func loadImage(id: String) -> Image? {
        if let avatarImage = lruFriendsImageCache.retrieveObject(at: id) {
            return avatarImage
        } else {
            var returnImage: Image?
            FirebaseRepository.getFromStorage(path: FIRKeys.StoragePath.profileImages+"/\(id)") { (result) in
                switch result {
                case .failure(let error):
                    print("failed to fetch user image: \(error)")
                    returnImage = Image(systemName: "person.circle.fill")
                case .success(let image):
                    self.lruFriendsImageCache.setObject(for: id, value: image)
                    returnImage = image
                }
            }
            return returnImage
        }
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
