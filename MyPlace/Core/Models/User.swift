//
//  User.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-03-11.
//

import SwiftUI

class User: ObservableObject, Identifiable {
    var id: String?
    var firstName: String?
    var lastName: String?
    var userName: String?
    var profileImageUrl: String?
}
