//
//  MyPlacesView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import SwiftUI

struct MyPlacesView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @StateObject private var viewModel = MyPlacesViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    ForEach(viewModel.places, id:\.uid) { place in
                        NavigationLink(
                            // MARK: TODO: Fetch from firebase and put in real images
                            destination: PlaceDetailView(viewModel: PlaceDetailViewModel(place: place, images: [Image("testimage"), Image("testimage"), Image("testimage"), Image("testimage")], distance: viewModel.getDistance(lat: place.lat, lng: place.lng))),
                            label: {
                                MyPlacesCellView(place: place, distance: viewModel.getDistance(lat: place.lat, lng: place.lng))
                                    .onAppear {
                                        // MARK: TODO: Pagination? Not sure how to implement it with firebase.
                                        // but if it always fetches it in order, this can be userd to trigger next fetch
                                        // whenever what item i want it to happen on.
                                    }
                            })
                        
                    }
                    .onDelete(perform: { indexSet in
                        // MARK: TODO: notify user with alert -> do real delete
                        viewModel.places.remove(atOffsets: indexSet)
                    })
                }
            }
            
            if viewModel.isLoading {
                ActivityView()
            }
        }
        .navigationBarTitle(LocalizedStringKey("Menu_myPlaces"), displayMode: .inline)
        .onAppear {
//            viewModel.user = userInfo.user
            viewModel.fetchData(for: userInfo.user.uid)
            viewModel.userLocation = userInfo.userLocation
        }
    }
}

struct MyPlacesView_Previews: PreviewProvider {
    static var previews: some View {
        MyPlacesView()
    }
}
