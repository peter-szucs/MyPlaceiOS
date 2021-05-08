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
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        MyButton(foreground: foregroundColor, background: backgroundColor, configuration: configuration)
    }
//    func makeBody(configuration: Self.Configuration) -> some View {
//        return configuration.label
//            .font(.headline)
//            .padding(.vertical)
//            .frame(width: UIScreen.main.bounds.width - 100, alignment: .center)
//            .foregroundColor(foregroundColor)
//            .background(isEnabled ? backgroundColor : .gray)
//            .cornerRadius(5)
//            .opacity(configuration.isPressed ? 0.6 : 1)
//            .scaleEffect(configuration.isPressed ? 0.9 : 1)
//            .animation(.easeInOut(duration: 0.2))
//    }
    
    struct MyButton: View {
        var foreground: Color
        var background: Color
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            configuration.label
                .font(.headline)
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 100, alignment: .center)
                .foregroundColor(foreground)
                .background(isEnabled ? background : .gray)
                .cornerRadius(5)
                .opacity(configuration.isPressed ? 0.6 : 1)
                .scaleEffect(configuration.isPressed ? 0.9 : 1)
                .animation(.easeInOut(duration: 0.2))
        }
    }
    
}
