//
//  ButtonViewRegular.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-02.
//

import SwiftUI

struct ButtonViewRegular: ButtonStyle {
    var foregroundColor: Color = .primary
    var backgroundColor: Color = .secondary
    
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .padding(.vertical)
            .frame(width: 250, alignment: .center)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(5)
            .opacity(configuration.isPressed ? 0.6 : 1)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeInOut(duration: 0.2))
    }
    
}
