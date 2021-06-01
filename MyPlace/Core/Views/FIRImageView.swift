//
//  FIRImageView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-31.
//

import SwiftUI

struct FIRImageView: View {
    
    @ObservedObject var imageLoader: FIRImageLoader
    
    init(id: String, cache: LRUCache<String, Image>) {
        imageLoader = FIRImageLoader(id: id, cache: cache)
    }
    
    var body: some View {
        VStack {
            imageLoader.image
                .resizable()
                .scaledToFill()
                .foregroundColor(Color("MainLightBlue"))
        }
    }
}

struct FIRImageView_Previews: PreviewProvider {
    static var previews: some View {
        FIRImageView(id: "sdf", cache: LRUCache<String, Image>(capacity: 1))
    }
}
