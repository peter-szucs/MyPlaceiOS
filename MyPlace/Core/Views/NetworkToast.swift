//
//  NetworkToast.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-23.
//

import SwiftUI

struct NetworkToast: View {
    
    var body: some View {
        HStack {
            Image(systemName: "wifi.slash")
                .padding(8)
            Text(LocalizedStringKey("NoNetwork"))
                .padding([.vertical, .trailing], 8)
        }
        .background(Color("TagNotSelected"))
        .clipShape(Capsule())
    }
}

struct NetworkToast_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id:\.self) {
            NetworkToast()
                .previewLayout(.sizeThatFits).preferredColorScheme($0)
        }
        
    }
}
