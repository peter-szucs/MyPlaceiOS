//
//  FriendDetailCellView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-19.
//

import SwiftUI

struct FriendDetailCellView: View {
    
    @State var place: Place
    var distance: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(place.title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                Spacer()
                Text(distance)
                    .font(.caption)
                    .padding(.trailing, 8)
            }
            Text(place.description)
                .lineLimit(1)
                .padding(.horizontal, 8)
            AddPlaceTagsView(tags: place.tags, size: 16)
                .padding([.horizontal, .bottom], 8)
            
        }
    }
}

struct FriendDetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        FriendDetailCellView(place: Place(uid: "", title: "Tenshii Tempura", description: "Fantastiskt ställe med väldigt god mat och trevlig personal, en dröm att vara där och sen lite mer text o skit, oj ojoj.", imageIDs: [], PMData: PlaceMarkAddress(), tagIds: [1, 3, 4, 5], lat: 0, lng: 0), distance: "2.3 km")
            .previewLayout(.sizeThatFits)
    }
}
