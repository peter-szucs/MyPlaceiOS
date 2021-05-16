//
//  PlaceDetailView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-14.
//

import SwiftUI

struct PlaceDetailView: View {
    
    @StateObject var viewModel: PlaceDetailViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                ZStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 32) {
                            if viewModel.place.images != nil {
                                ForEach(0..<viewModel.place.images!.count) { i in
                                    GeometryReader { proxy in
                                        VStack {
                                            let scale = viewModel.getScale(proxy: proxy)
                                            
                                            viewModel.place.images![i]
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 190, height: 190)
                                                .clipped()
                                                .cornerRadius(10)
                                                .shadow(radius: 5)
                                                .scaleEffect(CGSize(width: scale, height: scale))
                                                .animation(.easeOut(duration: 0.5))
                                        }
                                        .padding(.leading, viewModel.halfScreen - 132)
                                    }
                                    .frame(width: 200, height: 200)
                                }
                            } else {
                                Color.clear
                                    .frame(width: 0, height: 20)
                                    .padding(.leading, viewModel.halfScreen - 164)
                                Image(systemName: "photo")
                                    .scaleEffect(6)
                                    .frame(width: 200, height: 190)
                                    .foregroundColor(.gray)
                            }
                            
                            Color.clear
                                .frame(width: 0, height: 20)
                                .padding(.trailing, (viewModel.halfScreen - 164) + (viewModel.halfScreen - 132))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(32)
                    }
                    .padding(.bottom, 16)
                    
                    
                    if viewModel.isImagesLoading {
                        ActivityView()
                            .padding(70)
                            .background(Color("MainBW"))
                    }
                }
                .padding(.top, 10)
                Divider()
                    .padding(.horizontal, 16)
                VStack(alignment: .leading) {
                    HStack {
                        Text(viewModel.place.title)
                            .font(.title)
                            .fontWeight(.semibold)
                            .truncationMode(.tail)
                        Spacer()
                        Text(viewModel.distance)
                    }
                    Text("\(viewModel.place.PMData.PMAddress) \(viewModel.place.PMData.PMAddress2), \(viewModel.place.PMData.PMZipCode) \(viewModel.place.PMData.PMNeighbourhood)")
                        .font(.subheadline)
                    Text("\(viewModel.place.PMData.PMState), \(viewModel.place.PMData.PMCountry)")
                    AddPlaceTagsView(tags: viewModel.place.tags, size: 16)
                }
                .padding(.horizontal, 16)
                Divider()
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                Text(viewModel.place.description)
                    .padding(.horizontal, 16)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {}, label: {
                        Text("Take me there")
                    })
                    .buttonStyle(ButtonStyleRegular(foregroundColor: .white, backgroundColor: Color("MainBlue")))
                    .disabled(viewModel.isImagesLoading)
                    Spacer()
                }
                .padding(.vertical)
            }
        }
        // MARK: TODO: Localize
        .navigationBarTitle(viewModel.place.title)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailView(viewModel: PlaceDetailViewModel(place: Place(uid: "", title: "Home", description: "Best place in the world. Here we can enjoy a rich, healthy, benelovent atmosphere with lots of good food, awesome drinks, really long descriptions of the place.", imageIDs: ["dasf"], PMData: PlaceMarkAddress(name: "Home", thoroughfare: "Storgatan", subThoroughfare: "72", postalCode: "171 52", subLocality: "Solna", administrativeArea: "Stockholm", country: "Sverige"), tagIds: [0, 4, 6], lat: 0, lng: 0), distance: "1.2 km"))
    }
}
