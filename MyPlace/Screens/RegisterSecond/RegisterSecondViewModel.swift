//
//  RegisterSecondViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-04.
//

import SwiftUI
import Firebase

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
        return firstName != "" || lastName != "" || userName != ""
    }
    
    func finalizeRegistration() {
        isLoading = true
        uploadProfileImage()
    }
    
    func createUserDB() {
        print("createUserDB")
        if validateFields() {
            print("Fields validated")
            let data = ["firstName": firstName,
                        "lastName": lastName,
                        "userName": userName]
            guard let uid = Auth.auth().currentUser?.uid else {
                print("Current user dont exist")
                return
            }
            FirebaseRepository.addOrMergeUserToDb(data, uid: uid) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(_):
                    self.isLoading = false
                    self.finalizeReg = true
                }
            }
//            let db = Firestore.firestore().collection(FIRKeys.CollectionPath.users).document(Auth.auth().currentUser?.uid)
//            db.addDocument(data: data) { (error) in
//                if error != nil {
//                    print(error?.localizedDescription)
//                    self.isLoading = false
//                    return
//                }
//                self.isLoading = false
//                self.finalizeReg = true
//            }
        } else {
            // MARK: TODO: Create alert for user
            print("Fill in fields")
        }
    }
    
    func uploadProfileImage() {
        guard let uid = Auth.auth().currentUser?.uid else {
            isLoading = false
            print("failed UID check")
            return
        }
//        guard let imageToUpload = pickedImage?.jpegData(compressionQuality: 035) else {
//            print("Image to upload failed guard check")
//            isLoading = false
//            return
//        }
        let storageRef = Storage.storage().reference().child("profileImages").child("\(uid)")
        
        if pickedImage != nil {
            print("pickedImage != nil")
            storageRef.putData((pickedImage?.jpegData(compressionQuality: 0.35))!, metadata: nil) { (_, error) in
                if error != nil {
                    print(error?.localizedDescription)
                    self.isLoading = false
                    return
                }
                print("Successfully uploaded image")
                self.createUserDB()
            }
        } else {
            self.createUserDB()
        }
        
    }
}
