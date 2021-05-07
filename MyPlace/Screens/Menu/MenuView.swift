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
                destination: FriendsListView(),
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
                destination: SettingsView(),
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
                // MARK: TODO - Refactor
                viewModel.signOut()
                
            }, label: {
                VStack {
                    Image(systemName: "arrow.backward.square")
                    Text(LocalizedStringKey("SignOut"))
                        .font(.caption)
                }
            })
        })
        .onAppear {
            print(userInfo.user)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
