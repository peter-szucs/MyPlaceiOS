//
//  ViewModifiers.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-07.
//

import SwiftUI

struct UserInfoTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding([.leading, .trailing])
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

extension TextField {
    func textFieldStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}

extension SecureField {
    func textFieldStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}
