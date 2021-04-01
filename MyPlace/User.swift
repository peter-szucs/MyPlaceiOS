//
//  User.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-03-11.
//

import SwiftUI

class User: ObservableObject {
    @Published
    var firstName: String = ""
    var lastName: String = ""
    var userName: String = ""
    var profileImage: Image?
}
