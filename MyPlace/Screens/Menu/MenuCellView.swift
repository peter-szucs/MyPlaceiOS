//
//  MenuCellView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import SwiftUI

struct MenuCellView: View {
    
    var menuItem: MenuItem
    
    var body: some View {
        VStack {
            HStack {
                ZStack(alignment: .leading) {
                    Image(systemName: menuItem.iconName)
                        .foregroundColor(Color("MenuIcon"))
                    Text(menuItem.title)
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding(.leading, 60)
                }
                Spacer()
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width, height: 60)
    }
}

struct MenuCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MenuCellView(menuItem: MenuItem(id: 1, iconName: "person.3.fill", title: LocalizedStringKey("Menu_friends")))
                .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 60))
            MenuCellView(menuItem: MenuItem(id: 1, iconName: "eye", title: LocalizedStringKey("Menu_title")))
                .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 60))
        }
        
    }
}
