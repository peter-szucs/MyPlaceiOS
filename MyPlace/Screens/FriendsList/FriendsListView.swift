//
//  FriendsListView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import SwiftUI

struct FriendsListView: View {
    
    @StateObject private var viewModel = FriendsListViewModel()
    
    var body: some View {
        VStack {
            if viewModel.friendsList.count == 0 {
                Text("Nothing here yet.. 😢")
                    .padding()
                Spacer()
            } else {
                List(viewModel.friendsList, id: \.uid) { friend in
                    FriendsListCellView(user: friend)
                }
            }
            
        }
        .navigationBarTitle(Text(LocalizedStringKey("Menu_friends")), displayMode: .inline)
        .toolbar(content: {
            Button(action: {
                print("Add friend")
            }, label: {
                Image(systemName: "person.crop.circle.badge.plus")
            })
        })
    }
}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView()
    }
}
