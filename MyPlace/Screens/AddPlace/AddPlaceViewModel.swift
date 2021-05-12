//
//  AddPlaceViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-09.
//

import SwiftUI
import Combine

enum ActiveSheet: Identifiable {
    case first, second
    
    var id: Int {
        hashValue
    }
}

final class AddPlaceViewModel: ObservableObject {
    
    @Published var place = Place(uid: "", title: "", description: "", tagIds: [], lat: 0, lng: 0)
    @Published var isLoading = false
    @Published var activeSheet: ActiveSheet?
    @Published var images: [UIImage] = []
    @Published var pickedImagesArray: [UIImage] = []
    @Published var pickedImage: UIImage?
    @Published var emptyFieldsMessage: String = ""
    @Published var placeStatus: AddPlaceStatus = .noName
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // MARK: TODO: Localize
        isPlaceValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { placeStatus in
                switch placeStatus {
                case .noNameOrDescription:
                    self.placeStatus = .noNameOrDescription
                    return "Please fill in fields"
                case .noName:
                    self.placeStatus = .noName
                    return "Place must have a name"
                case .noDescription:
                    self.placeStatus = .noDescription
                    return "Please fill in a short description"
                case .validPlace:
                    self.placeStatus = .validPlace
                    return ""
                }
            }
            .assign(to: \.emptyFieldsMessage, on: self)
            .store(in: &cancellables)
        
    }
    
    // MARK: Public Functions
    
    func loadImages() {
        print("!!! preguard loadImages")
        guard let pickedImage = pickedImage else { return }
        images.append(pickedImage)
        pickedImagesArray.append(pickedImage)
        self.pickedImage = nil
        print("!!! loadImages succesfully completed: \(images.count)")
    }
    
    func finalizePlace(completion: @escaping (Bool) -> ()) {
        if placeStatus == .validPlace {
            print("!!! valid to upload")
            // MARK: TODO: Implement acivity screen in view
            isLoading = true
            uploadToFirestore { (isComplete) in
                self.isLoading = false
                completion(isComplete)
            }
        }
        print("!!! Not valid to upload", placeStatus)
        completion(false)
    }
    
    // MARK: Private Functions
    
    private func uploadToFirestore(completion: @escaping (Bool) -> ()) {
        let data = Place.dataDict(place: self.place)
        FirebaseRepository.addPlaceToDB(with: data) { (result) in
            switch result {
            case .failure(let error):
                print("error: \(error)")
                completion(false)
            case .success(let uid):
                if !self.images.isEmpty {
                    for image in self.images {
                        let resizedImage = image.resized(withPercentage: 0.2)
                        guard let imageData = resizedImage?.jpegData(compressionQuality: 0.5) else {
                            print("Image to upload failed guard check")
                            return
                        }
                        FirebaseRepository.uploadToStorage(uid: uid, path: FIRKeys.StoragePath.placeImages, imageData: imageData) { (result) in
                            switch result {
                            case .failure(let error):
                                print("VM failed to upload image: \(error)")
                            case .success(_):
                                print("VM Uploaded image")
                            }
                        }
                    }
                }
                completion(true)
            }
        }
        completion(false)
    }
    
    // MARK: Combine Publishers
    
    private var isPlaceValidPublisher: AnyPublisher<AddPlaceStatus, Never> {
        $place
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map {
                if $0.title == "" && $0.description == "" { return AddPlaceStatus.noNameOrDescription }
                if $0.title == "" { return AddPlaceStatus.noName }
                if $0.description == "" { return AddPlaceStatus.noDescription }
                return AddPlaceStatus.validPlace
            }
            .eraseToAnyPublisher()
    }
    
}

enum AddPlaceStatus {
    case noNameOrDescription, noName, noDescription, validPlace
}
