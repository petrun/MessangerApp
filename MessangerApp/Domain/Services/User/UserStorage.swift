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
    func getUser(uid: String, completion: @escaping (Result<User, Error>) -> Void)
    func getUsers(currentUserId: String, completion: @escaping (Result<[User], Error>) -> Void)
}

class UserStorage {
    private lazy var db = Firestore.firestore()
    private let collectionName = "users"
    private let firestoreWrapper: FirebaseFirestoreWrapperProtocol

    init(firestoreWrapper: FirebaseFirestoreWrapperProtocol) {
        self.firestoreWrapper = firestoreWrapper
    }
}

extension UserStorage: UserStorageProtocol {
    func addUser(user: User, completion: @escaping (Error?) -> Void) {
        do {
            firestoreWrapper.setData(
                ref: db.collection(collectionName).document(user.uid),
                data: try Firestore.Encoder().encode(user)
            ) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }

    func getUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        firestoreWrapper.getDocument(
            db.collection(collectionName).document(uid)
        ) { result in
            switch result {
            case .success(let document):
                do {
                    completion(.success(try document.data(as: User.self)!))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getUsers(currentUserId: String, completion: @escaping (Result<[User], Error>) -> Void) {
        firestoreWrapper.getDocuments(
            db.collection(collectionName).order(by: "createdAt", descending: true)
        ) { result in
            switch result {
            case .success(let documents):
                completion(.success(
                    documents
                        .compactMap { try? $0.data(as: User.self) }
                        .filter { $0.uid != currentUserId }
                ))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
