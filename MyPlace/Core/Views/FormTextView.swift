//
//  FormTextView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-04.
//

import SwiftUI

struct FormTextView: View {
    var text: LocalizedStringKey
    
    var body: some View {
        Text(text)
            .font(.callout)
            .bold()
            .multilineTextAlignment(.leading)
            .padding([.leading, .top])
    }
}
