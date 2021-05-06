//
//  MenuViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import SwiftUI

final class MenuViewModel: ObservableObject {
    
    @Published var menuItems: [MenuItem] = []
    @Published var menuDestinations = [FriendsListView(), MyPlacesView(), SettingsView()]
    
    init() {
        menuItems = [MenuItem(id: 0, iconName: "person.3.fill", title: LocalizedStringKey("Menu_friends")),
                     MenuItem(id: 1, iconName: "mappin.and.ellipse", title: LocalizedStringKey("Menu_myPlaces")),
                     MenuItem(id: 2, iconName: "gearshape.fill", title: LocalizedStringKey("Menu_profileSettings"))]
    }
    
}
