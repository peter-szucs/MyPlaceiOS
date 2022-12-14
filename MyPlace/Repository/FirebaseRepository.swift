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
import SwiftUI

final class FirebaseRepository {
    private var subscriptions = Set<AnyCancellable>()
    
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
    
    // Combine version
    /// Returns a publisher for when adding or altering the user to the DB
    /// - Parameters:
    ///     - data: Dictionary of the user
    ///     - uid: User id
    static func addOrMergeUserToDb(_ data: [String : Any], uid: String) -> AnyPublisher<Bool, Error> {
        let resultSubject = PassthroughSubject<Bool, Error>()
        let ref = Firestore.firestore().collection(FIRKeys.CollectionPath.users).document(uid)
        ref.setData(data, merge: true) { error in
            if let error = error {
                resultSubject.send(completion: .failure(error))
            }
            resultSubject.send(true)
        }
        return resultSubject.eraseToAnyPublisher()
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
    
    //Combine version
    /// Returns a publisher for adding a place to database
    /// - Parameters:
    ///     - data: Dictionary of data
    static func addPlaceToDB(with data: [String : Any]) -> AnyPublisher<String, Error> {
        let addPlaceFuture = Future<String, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            var ref: DocumentReference? = nil
            ref = Firestore.firestore().collection(FIRKeys.CollectionPath.users).document(uid).collection(FIRKeys.CollectionPath.places).addDocument(data: data) { (error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    guard let docID = ref?.documentID else { return }
                    promise(.success(docID))
                }
            }
        }
        return addPlaceFuture.eraseToAnyPublisher()
    }
    
    // MARK: - Retrieve Places
    // MARK: TODO: Figure out great way to use one function to fetch both from filters and full collections.
    // Maybe enums to choose between all types of fetches?
    
    static func getPlaceDocuments(for uid: String, completion: @escaping (Result<[Place], Error>) -> ()) {
        let db = Firestore.firestore()
        let settings = Firestore.firestore().settings
        db.settings = settings
        
        let reference = db.collection(FIRKeys.CollectionPath.users).document(uid).collection(FIRKeys.CollectionPath.places)
        
        var places: [Place] = []
        reference.getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(.failure(error))
            }
            
            if let documents = snapshot?.documents {
                for document in documents {
                    places.append(Place(documentData: document.data(), id: document.documentID)!)
                    
                }
                completion(.success(places))
            }
        }
    }
    
    // Combine Future version
    /// Returns a Publisher for an array of Place
    /// - Parameters:
    ///     - uid: Users UID
    static func getPlaceDocuments(for uid: String) -> AnyPublisher<[Place], Error> {
        let db = Firestore.firestore()
        let settings = Firestore.firestore().settings
        db.settings = settings
        
        let reference = db.collection(FIRKeys.CollectionPath.users).document(uid).collection(FIRKeys.CollectionPath.places)
        
        var places: [Place] = []
        let placeFetchFuture = Future<[Place], Error> { promise in
            reference.getDocuments { (snapshot, error) in
                if let error = error {
                    promise(.failure(error))
                }
                if let documents = snapshot?.documents {
                    for document in documents {
                        places.append(Place(documentData: document.data(), id: document.documentID)!)
                    }
                    promise(.success(places))
                }
            }
        }
        return placeFetchFuture.eraseToAnyPublisher()
    }
    
    // MARK: - Filtered Place Fetches
    
    static func getFilteredPlaces(filteredList: MapFilters, friendsList: [Friend], completion: @escaping (Result<[Friend], Error>) -> ()) {
        let filterDispatch = DispatchGroup()
        var ref: Query?
        var queryFriendsList: [Friend] = []
        var returnList: [Friend] = []
        if filteredList.selectedFriends.isEmpty {
            queryFriendsList = friendsList
        } else {
            queryFriendsList = filteredList.selectedFriends
        }
        
        for friend in queryFriendsList {
            filterDispatch.enter()
            var returnFriend = Friend(info: friend.info, status: friend.status)
            ref = Firestore.firestore().collection(FIRKeys.CollectionPath.users).document(friend.info.uid).collection(FIRKeys.CollectionPath.places)
            if !filteredList.selectedCountry.isEmpty {
                ref = ref?.whereField("pmData.countryCode", isEqualTo: filteredList.selectedCountry)
            }
            if !filteredList.selectedTags.isEmpty {
               ref = ref?.whereField("tags", arrayContainsAny: filteredList.selectedTags)
            }
            ref?.getDocuments(completion: { (querysnapshot, error) in
                if let error = error {
                    print("GetFilteredPlaces: Error fetching documents: \(error)")
                    completion(.failure(error))
                } else {
                    guard let documents = querysnapshot?.documents else {
                        print("GetFilteredPlaces: snapshot failed guard check")
                        return
                    }
                    for document in documents {
                        returnFriend.info.places.append(Place(documentData: document.data(), id: document.documentID)!)
                    }
                    if !returnFriend.info.places.isEmpty {
                        returnList.append(returnFriend)
                    }
                    
                    filterDispatch.leave()
                }
            })
        }
        filterDispatch.notify(queue: .global()) {
            print("### GetFilteredPlaces: Dispatched all fetches ###")
            completion(.success(returnList))
        }
    }
    
    // Combine Version
    /// Returns a publisher for filtered places
    /// - Parameters:
    ///     - filteredList: a filtered list of MapFilters
    ///     - friendsList: array of Friend
    
    static func getFilteredPlaces(filteredList: MapFilters, friendsList: [Friend]) -> AnyPublisher<[Friend], Error> {
        let filterDispatch = DispatchGroup()
        var ref: Query?
        var queryFriendsList: [Friend] = filteredList.selectedFriends.isEmpty ? friendsList : filteredList.selectedFriends
        var returnList: [Friend] = []
        
        let filteredPlacesFuture = Future<[Friend], Error> { promise in
            for friend in queryFriendsList {
                filterDispatch.enter()
                var returnFriend = Friend(info: friend.info, status: friend.status)
                ref = Firestore.firestore().collection(FIRKeys.CollectionPath.users).document(friend.info.uid).collection(FIRKeys.CollectionPath.places)
                if !filteredList.selectedCountry.isEmpty {
                    ref = ref?.whereField("pmData.countryCode", isEqualTo: filteredList.selectedCountry)
                }
                if !filteredList.selectedTags.isEmpty {
                   ref = ref?.whereField("tags", arrayContainsAny: filteredList.selectedTags)
                }
                ref?.getDocuments(completion: { (querysnapshot, error) in
                    if let error = error {
                        print("GetFilteredPlaces: Error fetching documents: \(error)")
                        promise(.failure(error))
                    } else {
                        guard let documents = querysnapshot?.documents else {
                            print("GetFilteredPlaces: snapshot failed guard check")
                            return
                        }
                        for document in documents {
                            returnFriend.info.places.append(Place(documentData: document.data(), id: document.documentID)!)
                        }
                        if !returnFriend.info.places.isEmpty {
                            returnList.append(returnFriend)
                        }
                        
                        filterDispatch.leave()
                    }
                })
            }
            filterDispatch.notify(queue: .global()) {
                print("### GetFilteredPlaces: Dispatched all fetches ###")
                promise(.success(returnList))
            }
        }
        return filteredPlacesFuture.eraseToAnyPublisher()
    }
    
    // MARK: - Retrieve User
    
    static func retrieveUser(uid: String, completion: @escaping (Result<User, Error>) -> ()) {
        let ref = Firestore.firestore().collection(FIRKeys.CollectionPath.users).document(uid)
        getDocument(for: ref) { (result) in
            switch result {
            case .success(let data):
                guard let user = User(documentData: data, uid: uid) else {
                    completion(.failure(FireStoreError.noUser))
                    return
                }
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Combine version
    /// Returns a publisher with the user
    /// - Parameters:
    ///    - uid: the uid for the user
    
    static func retrieveUser(with uid: String) -> AnyPublisher<User, Error> {
        let ref = Firestore.firestore().collection(FIRKeys.CollectionPath.users).document(uid)
        let returnUserPromise = Future<User, Error> { promise in
            getDocument(for: ref) { result in
                switch result {
                case .success(let data):
                    guard let user = User(documentData: data, uid: uid) else {
                        promise(.failure(FireStoreError.noUser))
                        return
                    }
                    promise(.success(user))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        return returnUserPromise.eraseToAnyPublisher()
    }
    
    // MARK: - Get Friendslist
#warning("See if changing the return value to be a Future instead of AnyCancellable. If good, do it everywhere in here (where applicable)")
    static func retrieveFriends(uid: String, completion: @escaping (Result<[Friend], Error>) -> ()) {
        let ref = Firestore.firestore().collection(FIRKeys.CollectionPath.friendRequests).document(uid).collection(FIRKeys.CollectionPath.requests)
        var friends: [Friend] = []
        let dispatchOne = DispatchGroup()
        ref.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            }
            if let documents = snapshot?.documents {
                for document in documents {
                    dispatchOne.enter()
                    retrieveUser(uid: document.documentID) { (result) in
                        switch result {
                        case .failure(let error):
                            print("!!! Error fetching user: \(error)")
                        case .success(let user):
                            friends.append(Friend(documentData: document.data(), user: user)!)
                        }
                        print("dispatch leave after: \(friends.count)")
                        dispatchOne.leave()
                    }
                }
                dispatchOne.notify(queue: .global()) {
                    print("dispatched friends: \(friends)")
                    completion(.success(friends))
                }
            }
        }
    }
    
    // Combine version
    /// Returns a publisher with an array of the FriendsCollection
    /// - Parameters:
    ///    - uid: The UID for the user
    
    static func retrieveFriends(uid: String) -> AnyPublisher<[Friend], Error> {
        let ref = Firestore.firestore().collection(FIRKeys.CollectionPath.friendRequests).document(uid).collection(FIRKeys.CollectionPath.requests)
        var friends: [Friend] = []
        let dispatchOne = DispatchGroup()
        let returnFuture = Future<[Friend], Error> { promise in
            ref.getDocuments { (snapshot, error) in
                if let error = error {
                    promise(.failure(error))
                }
                if let documents = snapshot?.documents {
                    for document in documents {
                        dispatchOne.enter()
                        retrieveUser(uid: document.documentID) { (result) in
                            switch result {
                            case .failure(let error):
                                print("!!! Error fetching user: \(error)")
                            case .success(let user):
                                friends.append(Friend(documentData: document.data(), user: user)!)
                            }
                            print("dispatch leave after: \(friends.count)")
                            dispatchOne.leave()
                        }
                    }
                    dispatchOne.notify(queue: .global()) {
                        print("dispatched friends: \(friends)")
                        promise(.success(friends))
                    }
                }
            }
        }
        return returnFuture.eraseToAnyPublisher()
    }
    
    // MARK: - Friends Listener
    
    static func friendCollectionListener(uid: String, completion: @escaping (FriendListenerReturn) -> ()) {
        
        print("!!! Starting friendListener for \(uid)")
        let ref = Firestore.firestore().collection(FIRKeys.CollectionPath.friendRequests).document(uid).collection(FIRKeys.CollectionPath.requests)
        ref.addSnapshotListener { (snapshot, error) in
            print("!!! inside listener")
            if let error = error {
                print("FIRRepo: FriendListener Error: \(error)")
            }
            guard let snap = snapshot else {
                print("FIRRepo: Error fetching snapshot in friendslistener: \(String(describing: error))")
                return
            }
            snap.documentChanges.forEach { (diff) in
                let status = diff.document.data()["status"] as? String ?? ""
                var friend = FriendListenerReturn(uid: diff.document.documentID, status: status, changeType: .added)
                
                switch diff.type {
                case .added:
                    print("!!! New friend Request: \(diff.document.data()), \(diff.document.documentID)")
                    friend.changeType = FriendListenerReturn.ChangeType(rawValue: diff.type.rawValue)!
                    completion(friend)
                case .modified:
                    print("!!! Modified request: \(diff.document.data()), \(diff.document.documentID)")
                    friend.changeType = FriendListenerReturn.ChangeType(rawValue: diff.type.rawValue)!
                    completion(friend)
                case .removed:
                    print("!!! Removed request: \(diff.document.data()), \(diff.document.documentID)")
                    friend.changeType = FriendListenerReturn.ChangeType(rawValue: diff.type.rawValue)!
                    completion(friend)
                }
                
//                if (diff.type == .added) {
//                    print("!!! New friend Request: \(diff.document.data()), \(diff.document.documentID)")
//                    friend.changeType = FriendListenerReturn.ChangeType(rawValue: diff.type.rawValue)!
//                    completion(friend)
//                }
//                if (diff.type == .modified) {
//                    print("!!! Modified request: \(diff.document.data()), \(diff.document.documentID)")
//                    friend.changeType = FriendListenerReturn.ChangeType(rawValue: diff.type.rawValue)!
//                    completion(friend)
//                }
//                if (diff.type == .removed) {
//                    print("!!! Removed request: \(diff.document.data()), \(diff.document.documentID)")
//                    friend.changeType = FriendListenerReturn.ChangeType(rawValue: diff.type.rawValue)!
//                    completion(friend)
//                }
            }
        }
    }
    
    // MARK: - Adding/Updating/Denying Friends
    
    static func searchForFriend(userName: String, completion: @escaping (Result<[User], Error>) -> ()) {
        let ref = Firestore.firestore().collection(FIRKeys.CollectionPath.users)
        var returnArray: [User] = []
        let dispatchOne = DispatchGroup()
        ref.whereField(FIRKeys.User.userName, isEqualTo: userName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("FIRRepo: Error getting document: \(error)")
                completion(.failure(error))
            } else {
                for document in querySnapshot!.documents {
                    dispatchOne.enter()
                    print("FIRRepo: user with username \(userName) found: \(document.data())")
                    guard let user = User(documentData: document.data(), uid: document.documentID) else {
                        print("FIRRepo: Document failed guard check.")
                        return
                    }
                    returnArray.append(user)
                    dispatchOne.leave()
                }
                dispatchOne.notify(queue: .global()) {
                    print("dispatchOne done")
                    completion(.success(returnArray))
                }
            }
        }
    }
    
    // Combine version
    /// Returns a future for a search result with an array of User or fails with an Error
    /// - Parameters:
    ///     - userName: User input name of search
    
    static func searchForFriend(userName: String) -> Future<[User], Error> {
        return Future() { promise in
            let ref = Firestore.firestore().collection(FIRKeys.CollectionPath.users)
            var returnArray: [User] = []
            let dispatchOne = DispatchGroup()
            
            ref.whereField(FIRKeys.User.userName, isEqualTo: userName).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("FIRRepo: Error getting document: \(error)")
                    promise(.failure(error))
                } else {
                    for document in querySnapshot!.documents {
                        dispatchOne.enter()
                        print("FIRRepo: user with username \(userName) found: \(document.data())")
                        guard let user = User(documentData: document.data(), uid: document.documentID) else {
                            print("FIRRepo: Document failed guard check.")
                            return
                        }
                        returnArray.append(user)
                        dispatchOne.leave()
                    }
                    dispatchOne.notify(queue: .global()) {
                        print("dispatchOne done")
                        promise(.success(returnArray))
                    }
                }
            }
        }
    }
    
    static func updateFriendRequests(status: String, uid: String, friendStatus: String, friendID: String, completion: @escaping (Bool) -> ()) {
        let userRef = Firestore.firestore().collection(FIRKeys.CollectionPath.friendRequests).document(uid).collection(FIRKeys.CollectionPath.requests).document(friendID)
        let friendRef = Firestore.firestore().collection(FIRKeys.CollectionPath.friendRequests).document(friendID).collection(FIRKeys.CollectionPath.requests).document(uid)
        
        let dispatch = DispatchGroup()
        userRef.updateData(["status" : status]) { error in
            dispatch.enter()
            if let error = error {
                print("UpdateRequest: Error writing document: \(error)")
                dispatch.leave()
                completion(false)
            } else {
                print("UpdateRequest: Document successfully written")
                dispatch.leave()
            }
        }
        friendRef.updateData(["status" : friendStatus]) { error in
            dispatch.enter()
            if let error = error {
                print("UpdateRequest: Error writing document: \(error)")
                dispatch.leave()
                completion(false)
            } else {
                print("UpdateRequest: Document successfully written")
                dispatch.leave()
            }
        }
        dispatch.notify(queue: .global()) {
            print("update Friend Dispatch done")
            completion(true)
        }
    }
    
    static func makeFriendRequest(uid: String, friendID: String, completion: @escaping (Bool) -> ()) {
        let userRef = Firestore.firestore().collection(FIRKeys.CollectionPath.friendRequests).document(uid).collection(FIRKeys.CollectionPath.requests).document(friendID)
        let friendRef = Firestore.firestore().collection(FIRKeys.CollectionPath.friendRequests).document(friendID).collection(FIRKeys.CollectionPath.requests).document(uid)
        
        let makeFriendDispatch = DispatchGroup()
        
        makeOrUpdateFriendRequestDocument(id: uid)
        makeOrUpdateFriendRequestDocument(id: friendID)
        
        userRef.setData(["status" : "sent"]) { error in
            makeFriendDispatch.enter()
            if let error = error {
                print("MakeRequest: Error writing document: \(error)")
                makeFriendDispatch.leave()
                completion(false)
            } else {
                print("MakeRequest: Document successfully written")
                
                makeFriendDispatch.leave()
            }
        }
        
        friendRef.setData(["status" : "recieved"]) { error in
            makeFriendDispatch.enter()
            if let error = error {
                print("MakeRequest: Error writing document: \(error)")
                makeFriendDispatch.leave()
                completion(false)
            } else {
                print("MakeRequest: Document successfully written")
                
                makeFriendDispatch.leave()
            }
        }
        
        makeFriendDispatch.notify(queue: .global()) {
            print("MakeRequest Dispatch done")
            completion(true)
        }
    }
    
    static func denyFriendRequest(uid: String, friendID: String) {
        let userRef = Firestore.firestore().collection(FIRKeys.CollectionPath.friendRequests).document(uid).collection(FIRKeys.CollectionPath.requests).document(friendID)
        let friendRef = Firestore.firestore().collection(FIRKeys.CollectionPath.friendRequests).document(friendID).collection(FIRKeys.CollectionPath.requests).document(uid)
        
        let array = [userRef, friendRef]
        
        for ref in array {
            ref.delete { (error) in
                if let error = error {
                    print("Deny Friend Request: Delete failed: \(error)")
                } else {
                    print("Deny Friend Request: Document successfully removed!")
                }
            }
        }
    }
    
    // To adress that the actual document for the user doesn't exist without having one field in it
    static private func makeOrUpdateFriendRequestDocument(id: String) {
        let ref = Firestore.firestore().collection(FIRKeys.CollectionPath.friendRequests).document(id)
        ref.setData(["lastEdited" : Timestamp(date: Date())]) { err in
            if let err = err {
                print("makeOrUpdateFRDoc: Error writing document: \(err)")
            } else  {
                print("makeOrUpdateFRDoc: successfully written")
            }
        }
    }
    
    // MARK: - Storage functions
    
    static func uploadToStorage(uid: String, imageID: String, path: String, imageData: Data, completion: @escaping (Result<Bool, Error>) -> ()) {
        var storageRef = Storage.storage().reference().child("dumpBox").child(UUID().uuidString)
        switch path {
        case FIRKeys.StoragePath.profileImages:
            storageRef = Storage.storage().reference().child(path).child(uid)
        case FIRKeys.StoragePath.placeImages:
            storageRef = Storage.storage().reference().child(path).child(uid).child(imageID)
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
    
    static func getFromStorage(path: String, completion: @escaping (Result<Image, Error>) -> ()) {
        let pathReference = Storage.storage().reference(withPath: path)
        
        pathReference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let image = UIImage(data: data!)
                completion(.success(Image(uiImage: image!)))
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

extension FirebaseRepository {
    enum FireStoreError: Error {
        case noAuthDataResult
        case noCurrentUser
        case noDocumentSnapshot
        case noCollectionSnapshot
        case noSnapshotData
        case noUser
    }

    enum FilterQuery {
        case all
        case onlyFriend
        case onlyTags
        case onlyCountries
        case friendAndTags
        case friendAndCountries
        case tagsAndCountries
    }
}
