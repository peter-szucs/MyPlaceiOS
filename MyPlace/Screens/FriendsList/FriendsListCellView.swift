//
//  FriendsListCellView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-07.
//

import SwiftUI

struct FriendsListCellView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @StateObject var viewModel: FriendsListViewModel
    @State var friend: Friend
    
    var body: some View {
        HStack {
            FIRImageView(id: friend.info.uid, cache: userInfo.lruFriendsImagesCache)
                .frame(width: 40, height: 40, alignment: .center)
                .clipShape(Circle())
                .padding(10)
            Text(friend.info.userName)
                .font(.title3)
            Spacer()
            if friend.status == "sent" {
                Text(LocalizedStringKey("FriendList_pending"))
                    .font(.callout)
                    .foregroundColor(Color("MainOrange"))
                    .padding(.trailing, 8)
            } else if friend.status == "recieved" {
                
                HStack(spacing: 16) {
                    Button(action: {
                        viewModel.handleFriendRequest(uid: userInfo.user.uid, friend: friend, accept: false) { (result) in
                            if result {
                                print("Deny")
//                                self.userInfo.handleFriendRequest(for: user, accept: false)
                            }
                        }
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    })
                    .buttonStyle(HighPriorityButtonStyle())
                    
                    Button(action: {
                        viewModel.handleFriendRequest(uid: userInfo.user.uid, friend: friend, accept: true) { (result) in
                            if result {
                                print("Accept!")
                            }
                        }
                    }, label: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    })
                    .buttonStyle(HighPriorityButtonStyle())
                    
                }
                .font(.title)
                .padding()
                
            }
        }
    }
}

struct FriendsListCellView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id:\.self) {
            FriendsListCellView(viewModel: FriendsListViewModel(), friend: Friend(info: User(uid: "", firstName: "Pete", lastName: "Switch", userName: "Pettin", friends: [], places: []), status: "filterScreen"))
                .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 80)).preferredColorScheme($0)
        }
    }
}


