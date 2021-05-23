//
//  SettingsViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-07.
//

import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {
    
    @Published var originalUserObject: User = User()
    @Published var newUserObject: User = User()
    @Published var showPickerAction = false
    @Published var changedImage: Image?
    @Published var pickedImage: UIImage?
    @Published var profileImage: Image = Image(systemName: "person.circle.fill")
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var userName: String = ""
    @Published var hasChanged: Bool = false
    @Published var isLoading: Bool = false
    @Published var editStatus: EditStatus = .unchanged
    
    var lruImageCache: LRUCache<String, Image>
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(cache: LRUCache<String, Image>, user: User) {
        self.originalUserObject = user
        self.newUserObject = user
        self.lruImageCache = cache
        setupProfileImage()
        
        editStatusPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.editStatus, on: self)
            .store(in: &cancellables)
        
        hasEditedAnythingPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.hasChanged, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Publishers
    
//    private var hasEditedAnythingPublisher: AnyPublisher<Bool, Never> {
//        Publishers.CombineLatest(hasChangedImagePublisher, hasEditedInfoPublisher)
//            .map { $0 || $1 }
//            .eraseToAnyPublisher()
//    }
    
    private var hasEditedAnythingPublisher: AnyPublisher<Bool, Never> {
        $editStatus
            .map { $0 != .unchanged }
            .eraseToAnyPublisher()
    }
    
    private var hasChangedImagePublisher: AnyPublisher<Bool, Never> {
        $changedImage
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
    
    private var hasEditedInfoPublisher: AnyPublisher<Bool, Never> {
        $newUserObject
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map {
                if $0.firstName != self.originalUserObject.firstName { return true }
                if $0.lastName != self.originalUserObject.lastName { return true }
                if $0.userName != self.originalUserObject.userName { return true }
                return false
            }
            .eraseToAnyPublisher()
    }
    
    private var editStatusPublisher: AnyPublisher<EditStatus, Never> {
        Publishers.CombineLatest(hasEditedInfoPublisher, hasChangedImagePublisher)
            .map {
                if $0 && $1 { return EditStatus.imageAndInfoChanged }
                else if $0 { return EditStatus.infoChanged }
                else if $1 { return EditStatus.imageChanged }
                return EditStatus.unchanged
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Public Functions
    
    func setUpInfo(user: User) {
        originalUserObject = user
        newUserObject = user
    }
    
    func loadImage() {
        guard let pickedImage = pickedImage else { return }
        changedImage = Image(uiImage: pickedImage)
    }
    
    func finalizeEditing(completion: @escaping (Bool) -> ()) {
        isLoading = true
        switch editStatus {
        case .imageAndInfoChanged:
            uploadNewImage { (result) in
                switch result {
                case .failure(_):
                    self.isLoading = false
                    // MARK: TODO: Handle alert toggle to alert user something went wrong
                    completion(false)
                case .success(_):
                    self.updateUserDatabase { (result) in
                        switch result {
                        case .failure(_):
                            self.isLoading = false
                            // MARK: TODO Handle alert
                            completion(false)
                        case .success(_):
                            self.isLoading = false
                            completion(true)
                        }
                    }
                }
            }
        case .imageChanged:
            uploadNewImage { (result) in
                switch result {
                case .failure(_):
                    self.isLoading = false
                    // MARK: TODO: Handle alert toggle to alert user something went wrong
                    completion(false)
                case .success(_):
                    self.isLoading = false
                    completion(true)
                }
            }
        case .infoChanged:
            updateUserDatabase { (result) in
                switch result {
                case .failure(_):
                    self.isLoading = false
                    // MARK: TODO Handle alert
                    completion(false)
                case .success(_):
                    self.isLoading = false
                    completion(true)
                }
            }
        case .unchanged:
            print("This should never happen")
            isLoading = false
            completion(false)
        }
        
    }
    
    // MARK: - Private Functions
    
    private func setupProfileImage() {
        guard let avatarImage = lruImageCache.retrieveObject(at: originalUserObject.uid) else { return }
        profileImage = avatarImage
    }
    
    private func uploadNewImage(completion: @escaping (Result<Bool, Error>) -> ()) {
        
        if pickedImage != nil {
            let resizedImage = pickedImage?.resized(withPercentage: 0.2)
            guard let imageData = resizedImage?.jpegData(compressionQuality: 0.5) else {
                print("Image to upload failed guard check")
                isLoading = false
                completion(.success(false))
                return
            }
            let image = Image(uiImage: resizedImage!)
            FirebaseRepository.uploadToStorage(uid: self.newUserObject.uid, imageID: "", path: FIRKeys.StoragePath.profileImages, imageData: imageData) { (result) in
                switch result {
                case .failure(let error):
                    self.isLoading = false
                    completion(.failure(error))
                case .success(_):
                    self.lruImageCache.setObject(for: self.newUserObject.uid, value: image)
                    completion(.success(true))
                }
            }
        } else {
            self.isLoading = false
            completion(.success(false))
        }
        
    }
    
    private func updateUserDatabase(completion: @escaping (Result<Bool, Error>) -> ()) {
        let data = User.dataDict(user: self.newUserObject)
        FirebaseRepository.addOrMergeUserToDb(data, uid: self.newUserObject.uid) { (result) in
            switch result {
            case .failure(let error):
                print("error uploading user: ", error)
                self.isLoading = false
                completion(.failure(error))
            case .success(_):
                completion(.success(true))
            }
        }
    }
}

enum EditStatus {
    case imageChanged
    case infoChanged
    case imageAndInfoChanged
    case unchanged
}
