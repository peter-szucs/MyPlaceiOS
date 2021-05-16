//
//  PlaceDetailViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-14.
//

import SwiftUI

final class PlaceDetailViewModel: ObservableObject {
    
    @Published var isImagesLoading = true
    @Published var place: Place
    @Published var showsIndicators = false
    @Published var halfScreen = UIScreen.main.bounds.width / 2
    @Published var distance: String
    
    init(place: Place, distance: String) {
        self.place = place
        self.distance = distance
        fetchImages()
    }
    
    private func fetchImages() {
        if place.imageIDs.isEmpty {
            isImagesLoading = false
        } else {
            var imageArray: [Image] = []
            var dlCounter = 0
            for imageLink in place.imageIDs {
                let path = FIRKeys.StoragePath.placeImages+"/\(place.uid)/\(imageLink)"
                FirebaseRepository.getFromStorage(path: path) { (result) in
                    switch result {
                    case .failure(let error):
                        print("failure to get image: \(error)")
                        dlCounter += 1
                    case .success(let image):
                        imageArray.append(image)
                        dlCounter += 1
                        if dlCounter == self.place.imageIDs.count {
                            self.place.images = imageArray
                            self.isImagesLoading = false
                        }
                    }
                }
            }
        }
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
