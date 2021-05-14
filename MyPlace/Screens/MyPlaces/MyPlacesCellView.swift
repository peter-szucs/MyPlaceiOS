//
//  MyPlacesCellView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-14.
//

import SwiftUI

struct MyPlacesCellView: View {
    
    var place: Place
    var distance: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(Color("MainLightBlue"))
                        .frame(width: 90, height: 90, alignment: .center)
                        .cornerRadius(5)
                        .clipped()
                        .padding(8)
                }
                VStack(alignment: .leading) {
                    Text(place.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(place.PMData.PMState)
                    AddPlaceTagsView(tags: place.tags, size: 16)
                        .frame(width: UIScreen.main.bounds.width - 160, alignment: .leading)
                    Text(distance + " from you")
                        .font(.caption)
                }
                Spacer()
            }
            .background(Color("PlaceListBackground"))
            .cornerRadius(10)
        }
    }
}

struct MyPlacesCellView_Previews: PreviewProvider {
    static var previews: some View {
        MyPlacesCellView(place: Place(uid: "", title: "My Fav place", description: "Test tes test testest setsetst sdga", PMData: PlaceMarkAddress(name: "Hopefully a place", thoroughfare: "CobberStreet", subThoroughfare: "44", postalCode: "555 55", subLocality: "SubLocality", administrativeArea: "Tokyo", country: "CobbelCountry"), tagIds: [1, 2, 3, 6, 7], lat: 12.23123, lng: 12.12345), distance: "1.2 km")
            .padding(8)
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 120))
    }
}
