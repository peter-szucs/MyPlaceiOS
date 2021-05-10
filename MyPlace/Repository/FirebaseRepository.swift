//
//  FirebaseRepository.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-04.
//

import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Combine

final class FirebaseRepository {
    
    @Published var places: [Place] = []
    
    func fetchPlaces(for userId: String) {
        Firestore.firestore().collection("users").document(userId).collection("places").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            guard let documents = snapshot else {
                print("No documents found")
                return
            }
            self.places = documents.documents.compactMap {
                try? $0.data() as? Place
            }
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
    
    // MARK: - Add Place in DB
    
    static func addPlaceToDB(with data: [String : Any], completion: @escaping (Result<String, Error>) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("!!! UID check failed")
            return
        }
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection(FIRKeys.CollectionPath.users).document(uid).collection(FIRKeys.CollectionPath.places).addDocument(data: data) { (error) in
            if let error = error {
                print("Error adding place doc: \(error)")
                completion(.failure(error))
            } else {
                print("Place doc added with ID: \(ref!.documentID)")
                completion(.success(ref!.documentID))
            }
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
    
    static func uploadToStorage(uid: String, path: String, imageData: Data, completion: @escaping (Result<Bool, Error>) -> ()) {
        var storageRef = Storage.storage().reference().child("dumpBox").child(UUID().uuidString)
        switch path {
        case FIRKeys.StoragePath.profileImages:
            storageRef = Storage.storage().reference().child(path).child(uid)
        case FIRKeys.StoragePath.placeImages:
            storageRef = Storage.storage().reference().child(path).child(uid).child(UUID().uuidString)
        default:
            print("!!! Something went very wrong!")
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if error != nil {
                print("Error uploading file: ", error ?? "")
                completion(.failure(error!))
            }
            if metadata != nil {
                print("Metadata: ", metadata!)
            }
            print("Successfully uploaded image", metadata ?? "")
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
