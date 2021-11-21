//
//  ChatStorage.swift
//  MessangerApp
//
//  Created by andy on 15.11.2021.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

enum ChatStorageError: Error {
  case chatNotFound(String)
}

protocol ChatStorageProtocol {
    typealias ChatId = String
//    func getChat(for users: [User], completion: @escaping (Result<Chat?, Error>) -> Void)
//    func createChat(for users: [User], completion: @escaping (Result<ChatId, Error>) -> Void)
    func createChat(chat: Chat, completion: @escaping (Result<ChatId, Error>) -> Void)
    func getPrivateChat(for users: [User], completion: @escaping (Result<Chat, Error>) -> Void)
//    func createChat(for user: User, andUser user2: User, completion: @escaping (Result<ChatId, Error>) -> Void)
    func getChats(for user: User, completion: @escaping (Result<[Chat], Error>) -> Void)
}

final class ChatStorage {
    private lazy var db = Firestore.firestore()
    private let collectionName = "chats"
}

 extension ChatStorage: ChatStorageProtocol {
    func createChat(chat: Chat, completion: @escaping (Result<ChatId, Error>) -> Void) {
        var ref: DocumentReference?
        ref = try? db.collection(collectionName).addDocument(from: chat, encoder: Firestore.Encoder()) { error in
            if let error = error {
                completion(.failure(error))
            } else if let ref = ref {
                completion(.success(ref.documentID))
            }
        }
    }

    func getPrivateChat(for users: [User], completion: @escaping (Result<Chat, Error>) -> Void) {
        let membersIds = users.map { $0.uid }
        db.collection(collectionName)
            .whereField("type", isEqualTo: ChatType.privateChat.rawValue)
            .whereField("membersIds.\(membersIds.first!)", isEqualTo: true)
            .whereField("membersIds.\(membersIds.last!)", isEqualTo: true)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let document = querySnapshot!.documents.first else {
                    completion(.failure(ChatStorageError.chatNotFound(
                        "Chat for members \(membersIds) not found"
                    )))
                    return
                }

                do {
                    completion(.success(try document.data(as: Chat.self)!))
                } catch {
                    completion(.failure(error))
                }
            }
    }

    func getChats(for user: User, completion: @escaping (Result<[Chat], Error>) -> Void) {
        db.collection(collectionName)
            .whereField("membersIds", arrayContains: user.uid)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                }

                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    completion(.success([]))
                    return
                }

                var chats = documents.compactMap { try? $0.data(as: Chat.self) }

                chats.sort { $0.lastUpdateAt ?? Date() > $1.lastUpdateAt ?? Date() }
                completion(.success(chats))
            }
    }

//    private  func listenForNewChats() {
//    }
//
//    private func checkForOldChats() {
//    }
 }
