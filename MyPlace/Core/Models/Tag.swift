//
//  Tag.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-09.
//

import Foundation

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
    func tagName() -> String {
        switch self {
        case .childFriendly:
            return "Child friendly"
        case .food:
            return "Food"
        case .drinks:
            return "Drinks"
        case .cafe:
            return "Café"
        case .playground:
            return "Playground"
        case .nightclub:
            return "Nightclub"
        case .park:
            return "Park"
        case .shopping:
            return "Shopping"
        case .undefined:
            return "Undefined"
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
