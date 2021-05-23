//
//  FirebaseImage.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-04-01.
//

import SwiftUI

let placeholderImage = Image(systemName: "person.circle.fill")

struct FirebaseImage: View {
    
    init(id: String) {
        self.imageLoader = ImageLoader(id)
    }
    
    @ObservedObject private var imageLoader: ImageLoader
    
    var image: UIImage? {
//        imageLoader.data.flatMap(UIImage.init)
        imageLoader.data
    }
    
    var body: some View {
        if image != nil {
            Image(uiImage: image!)
                .resizable()
                .scaledToFill()
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFill()
                .foregroundColor(Color("MainLightBlue"))
        }
    }
}

#if DEBUG
struct FirebaseImage_Previews: PreviewProvider {
    static var previews: some View {
        FirebaseImage(id: "random")
    }
}
#endif
