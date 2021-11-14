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
    
    @Published var place = Place()
    @Published var isLoading = false
    @Published var activeSheet: ActiveSheet?
    @Published var images: [UIImage] = []
    @Published var pickedImagesArray: [UIImage] = []
    @Published var pickedImage: UIImage?
    @Published var emptyFieldsMessage: String = ""
    @Published var placeStatus: AddPlaceStatus = .noName
    @Published var concatenatedAddressText: String = ""
        
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
        
        concatenatedAddressText = "\(place.PMData.PMName)\n\(place.PMData.PMAddress)\n\(place.PMData.PMZipCode) \(place.PMData.PMNeighbourhood) \(place.PMData.PMState)\n\(place.PMData.PMCountry)"
        
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
        let imageIdArray = makeImageIds()
        place.imageIDs = imageIdArray
        let data = Place.dataDict(place: self.place)
        FirebaseRepository.addPlaceToDB(with: data) { (result) in
            switch result {
            case .failure(let error):
                print("error: \(error)")
                completion(false)
            case .success(let uid):
                if !imageIdArray.isEmpty {
                    var uploadCounter = 0
                    for i in 0..<self.images.count {
                        let resizedImage = self.images[i].resized(withPercentage: 0.2)
                        guard let imageData = resizedImage?.jpegData(compressionQuality: 0.5) else {
                            print("Image to upload failed guard check")
                            return
                        }
                        FirebaseRepository.uploadToStorage(uid: uid, imageID: imageIdArray[i], path: FIRKeys.StoragePath.placeImages, imageData: imageData) { (result) in
                            switch result {
                            case .failure(_):
                                uploadCounter += 1
                                if uploadCounter == imageIdArray.count {
                                    completion(true)
                                }
                            case .success(_):
                                print("VM Uploaded image")
                                uploadCounter += 1
                                if uploadCounter == imageIdArray.count {
                                    completion(true)
                                }
                            }
                        }
                    }
                } else {
                    completion(true)
                }
            }
        }
        completion(false)
    }
    
    private func makeImageIds() -> [String] {
        var array: [String] = []
        for _ in self.images {
            let id = UUID().uuidString
            array.append(id)
        }
        return array
    }
    
    // MARK: Combine Publishers
    
    private var isPlaceValidPublisher: AnyPublisher<AddPlaceStatus, Never> {
        $place
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map {
                if $0.title == "" && $0.description == "" { return .noNameOrDescription }
                if $0.title == "" { return .noName }
                if $0.description == "" { return .noDescription }
                return .validPlace
            }
            .eraseToAnyPublisher()
    }
    
}

enum AddPlaceStatus {
    case noNameOrDescription, noName, noDescription, validPlace
}
