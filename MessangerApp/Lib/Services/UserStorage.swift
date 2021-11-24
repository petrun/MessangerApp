//
//  UserStorage.swift
//  MessangerApp
//
//  Created by andy on 11.11.2021.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol UserStorageProtocol {
//    func addUser(name: String, completion: @escaping (Result<String, Error>) -> Void)
    func addUser(user: User, completion: @escaping (Error?) -> Void)
    func getPage(
        lastSnapshot: DocumentSnapshot?,
        currentUserId: String,
        limit: Int,
        completion: @escaping (Result<[User], Error>) -> Void
    )
    func getUser(uid: String, completion: @escaping (Result<User, Error>) -> Void)
}

protocol CollectionProtocol {
    init(document: QueryDocumentSnapshot)
}

// @link for refactoring https://www.py4u.net/discuss/1535049

class UserStorage: UserStorageProtocol {
    private lazy var db = Firestore.firestore()

    func addUser(user: User, completion: @escaping (Error?) -> Void) {
        do {
            try db.collection("users")
                .document(user.uid)
                .setData(from: user, encoder: Firestore.Encoder()) { error in
                    completion(error)
                }
        } catch {
            completion(error)
        }
    }

    func getUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let snapshot = snapshot {
                do {
                    completion(.success(try snapshot.data(as: User.self)!))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

//    func fetchCollection<Collection: CollectionProtocol>(
//        lastSnapshot: DocumentSnapshot?,
//        query: Query,
//        completion: @escaping (Result<[Collection], Error>) -> Void
//    ) {
//        var first = query.limit(to: 1)
//
//        if let lastSnapshot = lastSnapshot {
//            first = query.start(afterDocument: lastSnapshot)
//        }
//
//        first.getDocuments { querySnapshot, error in
//            if let snapshot = querySnapshot {
//                // print(snapshot.metadata.isFromCache)
//                completion(.success(snapshot.documents.map { document -> Collection in
//                    return Collection(document: document)
//                }))
//            } else if let error = error {
//                completion(.failure(error))
//            }
//        }
//    }

/// https://coderoad.ru/58801932/Дженерики-Fetch-Firestore-collection
// https://www.codegrepper.com/code-examples/whatever/fetch+collection+data+firebase
// https://github.com/SD10/Nora
// https://stackoverflow.com/questions/61447677/firestore-pagination-get-next-batch-of-data
// https://stackoverflow.com/questions/52192062/pagination-with-firebase-firestore-swift-4

//    func fetchCollection<Collection: CollectionProtocol>(
//        lastSnapshot: DocumentSnapshot?,
//        query: Query,
//        completion: @escaping (Result<[Collection], Error>) -> Void
//    ) {
//        var first = query.limit(to: 1)
//
//        if let lastSnapshot = lastSnapshot {
//            first = query.start(afterDocument: lastSnapshot)
//        }
//
//        first.getDocuments { querySnapshot, error in
//            if let snapshot = querySnapshot {
//                // print(snapshot.metadata.isFromCache)
//                completion(.success(snapshot.documents.map { document -> Collection in
//                    return Collection(document: document)
//                }))
//            } else if let error = error {
//                completion(.failure(error))
//            }
//        }
//    }

    func getPage(
        lastSnapshot: DocumentSnapshot?,
        currentUserId: String,
        limit: Int,
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
//        var query = db
//            .collection("users")
        let text = "test1"
        var query = db.collection("users")
//            .filterBy(field: "name", prefix: text)
//            .whereField("users", arrayContains: "123")
//            .whereField("uid", isNotEqualTo: currentUserId)
//            .order(by: "uid")
            .order(by: "createdAt", descending: true)
            .limit(to: limit)

        if let lastSnapshot = lastSnapshot {
            query = query.start(afterDocument: lastSnapshot)
        }

        query.getDocuments { querySnapshot, error in
            if let snapshot = querySnapshot {
                completion(.success(
                    snapshot.documents
                        .compactMap { try? $0.data(as: User.self) }
                        .filter { $0.uid != currentUserId }
                ))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}

/// Фильтрация по префиксу
extension Query {
    func filterBy(field: String, prefix: String) -> Query {
        whereField("name", isGreaterThanOrEqualTo: prefix)
        .whereField("name", isLessThan: "\(prefix)\u{F7FF}")
    }
}
