//
//  ButtonStyleRegular.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-02.
//

import SwiftUI

struct ButtonStyleRegular: ButtonStyle {
    var foregroundColor: Color = .primary
    var backgroundColor: Color = .secondary
    
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .font(.headline)
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width - 100, alignment: .center)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(5)
            .opacity(configuration.isPressed ? 0.6 : 1)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.2))
    }
    
}
