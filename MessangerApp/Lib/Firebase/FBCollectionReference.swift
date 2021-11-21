//
//  FBCollectionReference.swift
//  MessangerApp
//
//  Created by andy on 16.11.2021.
//

import FirebaseFirestore

enum FBCollectionReference: String {
    case user
    case recent
    case messages
}

func firebaseReference(_ collectionReference: FBCollectionReference) -> CollectionReference {
    Firestore.firestore().collection(collectionReference.rawValue)
}
