//
//  FriendDetailView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-18.
//

import SwiftUI

struct FriendDetailView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @StateObject var viewModel: FriendDetailViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                FIRImageView(id: viewModel.friend.info.uid, cache: userInfo.lruFriendsImagesCache)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .padding()
                VStack(alignment: .leading) {
                    Text(viewModel.friend.info.userName)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.vertical)
                        .lineLimit(1)
                    Text("\(viewModel.friend.info.firstName) \(viewModel.friend.info.lastName)")
                    Spacer()
                }
            }
            .frame(height: 140)
            ZStack {
                List {
                    ForEach(viewModel.places, id:\.uid) { place in
                        NavigationLink(
                            destination: PlaceDetailView(viewModel: PlaceDetailViewModel(place: place, distance: place.getDistance(placeLat: place.lat, placeLng: place.lng, userLat: userInfo.userLocation.latitude, userLng: userInfo.userLocation.longitude))),
                            label: {
                                FriendDetailCellView(place: place, distance: place.getDistance(placeLat: place.lat, placeLng: place.lng, userLat: userInfo.userLocation.latitude, userLng: userInfo.userLocation.longitude))
                            })
                            .padding(.trailing, -32)
                    }
                }
                if viewModel.isLoading {
                    ActivityView()
                }
            }
        }
        .navigationBarTitle(viewModel.friend.info.userName, displayMode: .inline)
    }
}

struct FriendDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FriendDetailView(viewModel: FriendDetailViewModel(friend: Friend(info: User(uid: "", firstName: "Johnny", lastName: "Cash", userName: "musicman", friends: [], places: []), status: "accepted")))
    }
}
