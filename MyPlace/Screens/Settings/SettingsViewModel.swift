//
//  SettingsViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-07.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    @Published var originalUserObject: User = User(uid: "", firstName: "", lastName: "", userName: "", hasFinishedOnboarding: false)
    @Published var showPickerAction = false
    @Published var changedImage: Image?
    @Published var pickedImage: UIImage?
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var userName: String = ""
    
    func loadImage() {
        guard let pickedImage = pickedImage else { return }
        changedImage = Image(uiImage: pickedImage)
    }
}
