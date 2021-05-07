//
//  FriendsListViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-07.
//

import Foundation

final class FriendsListViewModel: ObservableObject {
    
    @Published var friendsList: [User] = []
    
    init() {
        // MARK: - fetch friends
    }
}
