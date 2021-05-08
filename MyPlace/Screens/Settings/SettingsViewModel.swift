//
//  SettingsViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-07.
//

import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {
    
    @Published var originalUserObject: User = User(uid: "", firstName: "", lastName: "", userName: "", hasFinishedOnboarding: false)
    @Published var showPickerAction = false
    @Published var changedImage: Image?
    @Published var pickedImage: UIImage?
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var userName: String = ""
    @Published var hasChanged: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        hasChangedImagePublisher
            .receive(on: RunLoop.main)
            .assign(to: \.hasChanged, on: self)
            .store(in: &cancellables)
    }
    
    private var hasChangedImagePublisher: AnyPublisher<Bool, Never> {
        $changedImage
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
    
    func setUpInfo(user: User) {
        originalUserObject = user
        firstName = user.firstName
        lastName = user.lastName
        userName = user.userName
    }
    
    func loadImage() {
        guard let pickedImage = pickedImage else { return }
        changedImage = Image(uiImage: pickedImage)
    }
}
