//
//  Tag.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-09.
//

import SwiftUI

struct Tag: Identifiable, Hashable {
    
    var id: Int
    var type: Tags? {
        Tags(rawValue: id)
    }
    
    init(typeValue: Int) {
        self.id = typeValue
    }
}

enum Tags: Int, CaseIterable {
    case childFriendly
    case food
    case drinks
    case cafe
    case playground
    case nightclub
    case park
    case shopping
    case undefined
    
    // MARK: TODO: Localize this
    func tagName() -> LocalizedStringKey {
        switch self {
        case .childFriendly:
            return LocalizedStringKey("tag_childfriendly")
        case .food:
            return LocalizedStringKey("tag_food")
        case .drinks:
            return LocalizedStringKey("tag_drinks")
        case .cafe:
            return LocalizedStringKey("tag_cafe")
        case .playground:
            return LocalizedStringKey("tag_playground")
        case .nightclub:
            return LocalizedStringKey("tag_nightclub")
        case .park:
            return LocalizedStringKey("tag_park")
        case .shopping:
            return LocalizedStringKey("tag_shopping")
        case .undefined:
            return LocalizedStringKey("tag_undefined")
        }
    }
    
    func tagIconName() -> String {
        switch self {
        case .childFriendly:
            return "childfriendly"
        case .food:
            return "food"
        case .drinks:
            return "drinks"
        case .cafe:
            return "cafe"
        case .playground:
            return "playground"
        case .nightclub:
            return "nightclub"
        case .park:
            return "park"
        case .shopping:
            return "shopping"
        case .undefined:
            return "undefined"
        }
    }
}
