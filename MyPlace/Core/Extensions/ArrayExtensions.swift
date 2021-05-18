//
//  ArrayExtensions.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-17.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
