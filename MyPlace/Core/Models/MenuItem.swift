//
//  MenuItem.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import SwiftUI

struct MenuItem: Identifiable {
    
    var id: Int
    var iconName: String
    var title: LocalizedStringKey
    
    init(id: Int, iconName: String, title: LocalizedStringKey) {
        self.id = id
        self.iconName = iconName
        self.title = title
    }
}
