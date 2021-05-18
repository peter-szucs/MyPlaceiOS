//
//  AddFriendView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-17.
//

import SwiftUI

struct AddFriendView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @StateObject var viewModel: FriendsListViewModel
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    TextField(LocalizedStringKey("FriendList_addPH"), text: $viewModel.friendSearchString)
                        .textFieldStyle(UserInfoTextFieldStyle())
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding(.top, 30)
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                            .padding(.trailing, 25)
                    }
                }
                Text(viewModel.friendSearchResultText)
                    .padding()
                Button(action: {
                    viewModel.performFriendSearch()
                }, label: {
                    Text(LocalizedStringKey("Search"))
                })
                .buttonStyle(ButtonStyleRegular(foregroundColor: .white, backgroundColor: Color("MainBlue")))
                .padding(.vertical)
                .disabled(viewModel.isFriendListLoading)
                List {
                    ForEach(viewModel.friendSearchList, id:\.uid) { user in
                        FriendsListCellView(viewModel: viewModel, user: Friend(info: user, status: "accepted"), userUID: userInfo.user.uid)
                            .onTapGesture {
                                viewModel.showingActionSheet = true
                            }
                            .actionSheet(isPresented: $viewModel.showingActionSheet) {
                                ActionSheet(title: Text("Send friendrequest?"), message: Text("Do you want to add \(user.userName) as a friend?"), buttons: [
                                    .default(Text("Yes")) { viewModel.sendFriendRequest(uid: userInfo.user.uid, friend: user) { (result) in
                                        if result {
                                            DispatchQueue.main.async {
                                                viewModel.tabSelection = 1
                                            }
                                        }
                                    } },
                                    .cancel()
                                ])
                            }
                    }
                }
            }
            if viewModel.isFriendListLoading {
                ActivityView()
            }
        }
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendView(viewModel: FriendsListViewModel(friendsList: []))
    }
}
