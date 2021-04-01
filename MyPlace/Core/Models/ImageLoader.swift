//
//  ImageLoader.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-04-01.
//

import SwiftUI
import Combine
import FirebaseStorage

final class ImageLoader: ObservableObject {
    let objectWillChange = PassthroughSubject<Data?, Never>()
    var data: Data? = nil {
        didSet { objectWillChange.send(data) }
    }
    
    init(_ id: String) {
        let url = "images/\(id)"
        let storage = Storage.storage()
        let ref = storage.reference().child(url)
        ref.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("\(error)")
            }
            
            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}
