//
//  FriendsListView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import SwiftUI

struct FriendsListView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @StateObject var viewModel: FriendsListViewModel
    
    var body: some View {
        
        ZStack {
            
            VStack {
                HStack(spacing: 0) {
                    ForEach(viewModel.tabTitles.indices, id:\.self) { index in
                        Text(viewModel.tabTitles[index])
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: viewModel.equalWidth, height: 40)
                            .background(viewModel.tabSelection == index ? Color("MainDarkBlue") : Color("MainBlue"))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    viewModel.tabSelection = index
                                }
                            }
                    }
                }
                TabView(selection: $viewModel.tabSelection) {
                    
                    VStack(alignment: .leading) {
                        List {
                            ForEach(viewModel.friendsList, id:\.info.uid) { friend in
                                NavigationLink(
                                    destination: Text("Destination"),
                                    label: {
                                        FriendsListCellView(viewModel: viewModel, user: friend, userUID: "")
                                    })
                                    .padding(.trailing, -32)
                            }
                        }
                    }.tag(0)
                    
                    VStack(alignment: .leading) {
                        Text("Friend Requests")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                        Divider()
                        List {
                            Section(header: Text("Recieved Requests")) {
                                ForEach(viewModel.recievedRequestList, id:\.info.uid) { friend in
                                    NavigationLink(
                                        destination: Text("Destination"),
                                        label: {
                                            FriendsListCellView(viewModel: viewModel, user: friend, userUID: userInfo.user.uid)
                                        })
                                        .padding(.trailing, -32)
                                }
                            }
                            Section(header: Text("Sent Requests")) {
                                ForEach(viewModel.sentRequestList, id:\.info.uid) { friend in
                                    NavigationLink(
                                        destination: Text("Destination"),
                                        label: {
                                            FriendsListCellView(viewModel: viewModel, user: friend, userUID: userInfo.user.uid)
                                        })
                                        .padding(.trailing, -32)
                                }
                            }
                            
                        }
                    }.tag(1)
                    
                    VStack(alignment: .leading) {
                        Text("Add Friends")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                        Divider()
                        AddFriendView(viewModel: viewModel)
                    }.tag(2)
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .hidden(viewModel.isLoading)
            }
            
            if viewModel.isLoading {
                ActivityView()
            }
            
        }
        .navigationBarTitle(Text(LocalizedStringKey("Menu_friends")), displayMode: .inline)    }
}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView(viewModel: FriendsListViewModel(friendsList: [Friend(info: User(uid: "dfg34gsdrfg34", firstName: "John", lastName: "Appleseed", userName: "Johnny", friends: []), status: "accepted"), Friend(info: User(uid: "234g4352g45g", firstName: "Greg", lastName: "Sender", userName: "Friendsender1000", friends: []), status: "sent"), Friend(info: User(uid: "", firstName: "Bob", lastName: "Hope", userName: "BobbyBoy", friends: []), status: "recieved")]))
    }
}
