//
//  RegisterSecondViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-04.
//

import SwiftUI
import FirebaseAuth

final class RegisterSecondViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var userName: String = ""
    @Published var isLoading: Bool = false
    @Published var showPickerAction = false
    @Published var profileImage: Image?
    @Published var pickedImage: UIImage?
    @Published var finalizeReg: Bool = false
    
    func loadImage() {
        guard let pickedImage = pickedImage else { return }
        profileImage = Image(uiImage: pickedImage)
    }
    
    func validateFields() -> Bool {
        return firstName != "" && lastName != "" && userName != ""
    }
    
    func finalizeRegistration(completion: @escaping (Bool) -> ()) {
        isLoading = true
        if validateFields() {
            guard let uid = Auth.auth().currentUser?.uid else {
                isLoading = false
                print("failed UID check")
                completion(false)
                return
            }
            
            if pickedImage != nil {
                print("pickedImage size: ", pickedImage?.size ?? "")
                let resizedImage = pickedImage?.resized(withPercentage: 0.2)
                print("resizedImage size: ", resizedImage?.size ?? "")
                guard let imageData = resizedImage?.jpegData(compressionQuality: 0.5) else {
                    print("Image to upload failed guard check")
//                    isLoading = false
                    return
                }
                FirebaseRepository.uploadToStorage(uid: uid, imageID: "", path: FIRKeys.StoragePath.profileImages, imageData: imageData) { (result) in
                    switch result {
                    case .failure(let error):
                        print(error)
//                        self.isLoading = false
                        return
                    case .success(_):
                        print("Image uploaded successfully")
                    }
                }
            }
            let data = User.dataDict(firstName: firstName, lastName: lastName, userName: userName)
            
            FirebaseRepository.addOrMergeUserToDb(data, uid: uid) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(_):
                    self.isLoading = false
                    self.finalizeReg = true
                    completion(true)
                }
            }
            
        } else {
            // MARK: TODO: Create alert or text on screen for user
            print("Fill in fields")
            isLoading = false
        }
    }
}
