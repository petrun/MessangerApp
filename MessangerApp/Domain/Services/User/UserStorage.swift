//
//  UserStorage.swift
//  MessangerApp
//
//  Created by andy on 11.11.2021.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol UserStorageProtocol {
    func createUserData(uid: String, user: User, completion: @escaping (Error?) -> Void)
    func updateUserData(uid: String, data: [String: Any], completion: @escaping (Error?) -> Void)
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
    func createUserData(uid: String, user: User, completion: @escaping (Error?) -> Void) {
        let ref = db.collection(collectionName).document(uid)
        do {
            let data: [String: Any] = try Firestore.Encoder().encode(user)
            firestoreWrapper.setData(ref: ref, data: data, completion: completion)
        } catch {
            completion(error)
        }
    }

    func updateUserData(uid: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        let ref = db.collection(collectionName).document(uid)
        firestoreWrapper.updateData(ref: ref, data: data, completion: completion)
    }

    func getUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        firestoreWrapper.getDocument(
            db.collection(collectionName).document(uid)
        ) { result in
            switch result {
            case .success(let document):
                if !document.exists {
                    completion(.failure(FirebaseError.documentNotFound))
                    print("User \(uid) not found")
                    return
                }

                do {
                    completion(.success(try document.data(as: User.self)!))
                } catch {
                    completion(.failure(error))
                    print("Error user unwrap", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("Error get user", error)
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
