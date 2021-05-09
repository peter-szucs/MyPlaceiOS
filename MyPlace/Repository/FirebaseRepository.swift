//
//  FirebaseRepository.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-04.
//

import Firebase
import Combine

final class FirebaseRepository: ObservableObject {
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    @Published var places: [Place] = []
    
    func fetchPlaces(for userId: String) {
        db.collection("users").document(userId).collection("places").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.places = snapshot?.documents.compactMap {
                try? $0.data() as? Place
            } ?? []
        }
    }
    
    // MARK: - Add or update userclass in DB
    
    static func addOrMergeUserToDb(_ data: [String : Any], uid: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        let ref = Firestore.firestore().collection(FIRKeys.CollectionPath.users).document(uid)
        ref.setData(data, merge: true) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(true))
        }
    }
    
    // MARK: - Retrieve User
    
    static func retrieveUser(uid: String, completion: @escaping (Result<User, Error>) -> ()) {
        let ref = Firestore.firestore().collection(FIRKeys.CollectionPath.users).document(uid)
        getDocument(for: ref) { (result) in
            switch result {
            case .success(let data):
                guard let user = User(documentData: data) else {
                    completion(.failure(FireStoreError.noUser))
                    return
                }
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Storage functions
    // MARK: TODO: Add FIRKeys value for path
    
    static func uploadToStorage(uid: String, imageData: Data, completion: @escaping (Result<Bool, Error>) -> ()) {
        let storageRef = Storage.storage().reference().child(FIRKeys.StoragePath.profileImages).child("\(uid)")
        
        // MARK: TODO: If or switch statement to set correct path
//        let storageRef = Storage.storage().reference().child(FIRKeys.StoragePath.placeImages).child("\(uid)").child(UUID().uuidString)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if error != nil {
                print("Error uploading file: ", error ?? "")
                completion(.failure(error!))
            }
            if metadata != nil {
                print("Metadata: ", metadata)
            }
            print("Successfully uploaded image")
            completion(.success(true))
        }
    }
    
    static func deleteFromStorage(uid: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        let storageRef = Storage.storage().reference().child("profileImages").child("\(uid)")
        
        storageRef.delete { (error) in
            if let error = error {
                print("Error deleting file: ", error)
                completion(.failure(error))
            } else {
                print("File deleted succesfully")
                completion(.success(true))
            }
        }
    }
    
    // MARK: - Inner functions
    
    fileprivate static func getDocument(for reference: DocumentReference, completion: @escaping (Result<[String : Any], Error>) -> ()) {
        reference.getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = snapshot else {
                completion(.failure(FireStoreError.noDocumentSnapshot))
                return
            }
            guard let data = snapshot.data() else {
                completion(.failure(FireStoreError.noSnapshotData))
                return
            }
            completion(.success(data))
        }
    }
}

enum FireStoreError: Error {
    case noAuthDataResult
    case noCurrentUser
    case noDocumentSnapshot
    case noSnapshotData
    case noUser
}
