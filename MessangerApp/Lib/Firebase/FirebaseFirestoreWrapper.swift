//
//  FirebaseFirestoreWrapper.swift
//  MessangerApp
//
//  Created by andy on 30.11.2021.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

enum FirebaseError: Error {
    case documentNotFound
}

protocol FirebaseFirestoreWrapperProtocol {
    func addListener(
        query: Query,
        completion: @escaping (Result<[DocumentChange], Error>) -> Void
    ) -> ListenerRegistration

    func getDocument(
        _ ref: DocumentReference,
        completion: @escaping (Result<DocumentSnapshot, Error>) -> Void
    )

    func getDocument(
        _ query: Query,
        completion: @escaping (Result<QueryDocumentSnapshot, Error>) -> Void
    )

    func getDocuments(
        _ query: Query,
        completion: @escaping (Result<[QueryDocumentSnapshot], Error>) -> Void
    )

    func updateData(
        ref: DocumentReference,
        data: [String: Any],
        completion: @escaping ((Error?) -> Void)
    )

    func setData(
        ref: DocumentReference,
        data: [String: Any],
        completion: @escaping ((Error?) -> Void)
    )
}

class FirebaseFirestoreWrapper: FirebaseFirestoreWrapperProtocol {
    func addListener(
        query: Query,
        completion: @escaping (Result<[DocumentChange], Error>) -> Void
    ) -> ListenerRegistration {
        query.addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let snapshot = querySnapshot else { return }
            completion(.success(snapshot.documentChanges))
        }
    }

    func getDocument(
        _ ref: DocumentReference,
        completion: @escaping (Result<DocumentSnapshot, Error>) -> Void
    ) {
        ref.getDocument { snapshot, error in
            if let snapshot = snapshot {
                completion(.success(snapshot))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

    func getDocument(
        _ query: Query,
        completion: @escaping (Result<QueryDocumentSnapshot, Error>) -> Void
    ) {
        query
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let document = querySnapshot!.documents.first else {
                    completion(.failure(FirebaseError.documentNotFound))
                    return
                }

                completion(.success(document))
            }
    }

    func getDocuments(
        _ query: Query,
        completion: @escaping (Result<[QueryDocumentSnapshot], Error>) -> Void
    ) {
        query
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                }

                guard let documents = querySnapshot?.documents else {
                    completion(.success([]))
                    return
                }

                completion(.success(documents))
            }
    }

    func updateData(
        ref: DocumentReference,
        data: [String: Any],
        completion: @escaping ((Error?) -> Void)
    ) {
        ref.updateData(data, completion: completion)
    }

    func setData(
        ref: DocumentReference,
        data: [String: Any],
        completion: @escaping ((Error?) -> Void)
    ) {
        ref.setData(data, completion: completion)
    }
}
