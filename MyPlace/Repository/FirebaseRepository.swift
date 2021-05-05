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
}
