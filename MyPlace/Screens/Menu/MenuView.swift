//
//  SettingsView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import SwiftUI

struct MenuView: View {
    
    @StateObject private var viewModel = MenuViewModel()
    
    var body: some View {
        
        VStack(alignment: .center) {
            List(viewModel.menuItems) { item in
//                NavigationLink(
//                    destination: viewModel.menuDestinations[item.id],
//                    label: {
//                        MenuCellView(menuItem: item)
//                    })
                Divider().frame(width: UIScreen.main.bounds.width - 50)
            }
            Spacer()
        }
        // MARK: TODO - Localize
        .navigationBarTitle(LocalizedStringKey("Menu_title"))
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
