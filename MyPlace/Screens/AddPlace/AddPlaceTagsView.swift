//
//  AddPlaceTagsView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-09.
//

import SwiftUI

struct AddPlaceTagsView: View {
    
    var tags: [Tag]
    var size: CGFloat?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                if tags.isEmpty {
                    Color.clear
                        .frame(width: size ?? 24, height: size ?? 24)
                } else {
                    ForEach(tags) { tag in
                        Image((tag.type?.tagIconName()) ?? "undefined")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFill()
                            .foregroundColor(Color("MainLightBlue"))
                            .frame(width: size ?? 24, height: size ?? 24)
    //                        .padding(.trailing, 10)
                    }
                }
                
            }
        }
    }
}

struct AddPlaceTagsView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceTagsView(tags: [Tag(typeValue: 0), Tag(typeValue: 4), Tag(typeValue: 1), Tag(typeValue: 5)])
            .previewLayout(.sizeThatFits)
        
    }
}
