//
//  SettingsView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import SwiftUI

struct MenuView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @StateObject private var viewModel = MenuViewModel()
    
    var body: some View {
        
        VStack(alignment: .center) {
            NavigationLink(
                destination: FriendsListView(viewModel: FriendsListViewModel()),
                label: {
                    MenuCellView(menuItem: viewModel.menuItems[0])
                })
                .padding(.top, 20)
            Divider().frame(width: UIScreen.main.bounds.width - 50)
            NavigationLink(
                destination: MyPlacesView(),
                label: {
                    MenuCellView(menuItem: viewModel.menuItems[1])
                })
            Divider().frame(width: UIScreen.main.bounds.width - 50)
            NavigationLink(
                destination: SettingsView(viewModel: SettingsViewModel(cache: userInfo.lruUserImageCache, user: userInfo.user)),
                label: {
                    MenuCellView(menuItem: viewModel.menuItems[2])
                })
            Divider().frame(width: UIScreen.main.bounds.width - 50)
            Spacer()
        }
        // MARK: TODO - Localize
        .navigationBarTitle(Text(LocalizedStringKey("Menu_title")), displayMode: .inline)
        .toolbar(content: {
            Button(action: {
                viewModel.signOut()
            }, label: {
                VStack {
//                    Image(systemName: "lock.square")
                    Text(LocalizedStringKey("SignOut"))
                        .font(.caption)
                }
            })
        })
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
