//
//  MapBottomMenuIcon.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-08.
//

import SwiftUI

struct MapBottomMenuIcon: View {
    
    var iconSystemName: String
    var iconTitle: LocalizedStringKey
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: iconSystemName)
                .scaleEffect(2)
            Text(iconTitle)
                .font(.footnote)
            
        }
        .padding(EdgeInsets(top: 20,
                            leading: 30,
                            bottom: 0,
                            trailing: 30))
        .foregroundColor(Color("BottomMapMenuIcons"))
    }
}

struct MapBottomMenuIcon_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MapBottomMenuIcon(iconSystemName: "ellipsis.rectangle", iconTitle: LocalizedStringKey("Menu_title"))
                .previewLayout(.fixed(width: 250, height: 80))
            MapBottomMenuIcon(iconSystemName: "line.horizontal.3.decrease.circle", iconTitle: LocalizedStringKey("Menu_title"))
                .previewLayout(.fixed(width: 250, height: 80))
        }
    }
}
