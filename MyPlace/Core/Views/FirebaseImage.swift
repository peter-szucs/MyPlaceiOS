//
//  FirebaseImage.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-04-01.
//

import SwiftUI

let placeholderImage = UIImage(systemName: "person.circle.fill")!

struct FirebaseImage: View {
    
    init(id: String) {
        self.imageLoader = ImageLoader(id)
    }
    
    @ObservedObject private var imageLoader: ImageLoader
    
    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }
    
    var body: some View {
        Image(uiImage: image ?? placeholderImage)
            .resizable()
            .scaledToFill()
            .foregroundColor(Color("MainLightBlue"))
    }
}

#if DEBUG
struct FirebaseImage_Previews: PreviewProvider {
    static var previews: some View {
        FirebaseImage(id: "random")
    }
}
#endif
