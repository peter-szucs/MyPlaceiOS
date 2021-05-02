//
//  ButtonViewRegular.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-02.
//

import SwiftUI

struct ButtonViewRegular: View {
    var title: String = ""
    var bgColor: Color
    var foregroundColor: Color
    
    var body: some View {
        Text(title)
            .frame(width: 250, alignment: .center)
            .padding()
            .foregroundColor(foregroundColor)
            .background(bgColor)
            .cornerRadius(5)
    }
    
}

struct ButtonRegular_Previews: PreviewProvider {
    static var previews: some View {
        ButtonViewRegular(title: "Test Button", bgColor: Color("MainBlue"), foregroundColor: .white)
    }
}
