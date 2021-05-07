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
