//
//  PlaceDetailViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-14.
//

import SwiftUI

final class PlaceDetailViewModel: ObservableObject {
    
    @Published var place: Place
    @Published var showsIndicators = false
    @Published var images: [Image]
    @Published var halfScreen = UIScreen.main.bounds.width / 2
    @Published var distance: String
    
    init(place: Place, images: [Image], distance: String) {
        self.place = place
        self.images = images
        self.distance = distance
    }
    
    func getScale(proxy: GeometryProxy) -> CGFloat {
        var scale: CGFloat = 1
        let max = halfScreen - 32
        let x = proxy.frame(in: .global).minX
        let diff = abs(x - 32)
        if diff < max {
            scale = 1 + (max - diff) / 500
        }
        return scale
    }
    
    func areNameAndAddressSame() -> Bool {
        let concatedAddress: String = "\(place.PMData.PMAddress) \(place.PMData.PMAddress2)"
        print(concatedAddress == place.PMData.PMName)
        return concatedAddress == place.PMData.PMName
    }
}
