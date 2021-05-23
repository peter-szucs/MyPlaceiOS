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
                            ForEach(userInfo.friendsList, id:\.info.uid) { friend in
                                NavigationLink(
                                    destination: FriendDetailView(viewModel: FriendDetailViewModel(friend: friend, cache: userInfo.lruFriendsImagesCache)),
                                    label: {
                                        FriendsListCellView(viewModel: viewModel, friend: friend)
                                    })
                                    .padding(.trailing, -32)
                            }
                        }
                        .padding(.top)
                    }.tag(0)
                    
                    VStack(alignment: .leading) {
                        List {
                            Section(header: Text("Recieved Requests")) {
                                ForEach(userInfo.recievedRequestList, id:\.info.uid) { friend in
                                    FriendsListCellView(viewModel: viewModel, friend: friend)
                                }
                            }
                            Section(header: Text("Sent Requests")) {
                                ForEach(userInfo.sentRequestList, id:\.info.uid) { friend in
                                    FriendsListCellView(viewModel: viewModel, friend: friend)
                                }
                            }
                            
                        }
                        .padding(.top)
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
        FriendsListView(viewModel: FriendsListViewModel(cache: LRUCache<String, Image>(capacity: 1)))
    }
}
