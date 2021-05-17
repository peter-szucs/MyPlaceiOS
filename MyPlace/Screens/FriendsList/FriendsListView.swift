//
//  FriendsListView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import SwiftUI

struct FriendsListView: View {
    
    @StateObject var viewModel: FriendsListViewModel
    
    @State var offset: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            
            let rect = proxy.frame(in: .global)
            
            ScrollableTabBarView(tabs: tabs, rect: rect, offset: $offset) {
                HStack(spacing: 0) {
                    ForEach((0..<3), id:\.self) { i in
                        VStack {
                            
                            if viewModel.allLists[i].count == 0 {
                                Text("Nothing here yet.. 😢")
                                    .padding()
                                Spacer()
                            } else {
                                List(viewModel.allLists[i], id: \.info.uid) { friend in
                                    FriendsListCellView(user: friend.info)
                                }
                            }

                        }
                        .padding(.top, 60)
                    }
                    
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
        .overlay(TabBarView(offset: $offset), alignment: .top)
        
    }
}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView(viewModel: FriendsListViewModel(friendsList: [Friend(info: User(uid: "dfg34gsdrfg34", firstName: "John", lastName: "Appleseed", userName: "Johnny", friends: []), status: "accepted"), Friend(info: User(uid: "234g4352g45g", firstName: "Greg", lastName: "Sender", userName: "Friendsender1000", friends: []), status: "sent"), Friend(info: User(uid: "", firstName: "Bob", lastName: "Hope", userName: "BobbyBoy", friends: []), status: "recieved")]))
    }
}

let tabs = ["Friends", "Sent", "Invites"]
