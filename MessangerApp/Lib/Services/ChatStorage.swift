//
//  ChatStorage.swift
//  MessangerApp
//
//  Created by andy on 15.11.2021.
//

import FirebaseFirestore

enum ChatChange {
    case added(Chat)
    case modified(Chat)
}

enum ChatStorageError: Error {
    case chatNotFound(String)
    case cantDecodeChatData(String)
}

protocol ChatStorageProtocol {
    func addListener(
        for user: User,
        completion: @escaping (Result<ChatChange, Error>) -> Void
    ) -> ListenerRegistration
    func createChat(recipient: User, completion: @escaping (Result<Chat, Error>) -> Void)
    func getChat(for users: [User], completion: @escaping (Result<Chat, Error>) -> Void)
    func getChats(for user: User, completion: @escaping (Result<[Chat], Error>) -> Void)
    func setLastMessage(chat: Chat, message: Message, completion: @escaping (Error?) -> Void)
}

final class ChatStorage {
    private lazy var db = Firestore.firestore()
    private let collectionName = "chats"
    private let chatDataMapper: ChatDataMapper
    private let firebaseFirestoreWrapper: FirebaseFirestoreWrapperProtocol

    init(chatDataMapper: ChatDataMapper, firestoreWrapper: FirebaseFirestoreWrapperProtocol) {
        self.chatDataMapper = chatDataMapper
        self.firebaseFirestoreWrapper = firestoreWrapper
    }
}

 extension ChatStorage: ChatStorageProtocol {
    func addListener(
        for user: User,
        completion: @escaping (Result<ChatChange, Error>) -> Void
    ) -> ListenerRegistration {
        firebaseFirestoreWrapper.addListener(
            query: db
                .collection(collectionName)
                .whereField("membersIds.\(user.uid)", isEqualTo: true)
            // Для фильтрации по lastUpdateAt требуется индекс по membersIds.uid и lastUpdateAt
//                .whereField("lastUpdateAt", isGreaterThan: lastChat?.lastUpdateAt ?? Date())
        ) { [weak self] result in
            switch result {
            case .success(let documentChanges):
                for change in documentChanges {
                    switch change.type {
                    case .added:
                        self?.chatDataMapper.toObject(data: change.document.data()) { chat in
                            guard let chat = chat else { return }
                            completion(.success(ChatChange.added(chat)))
                        }
                    case .modified:
                        self?.chatDataMapper.toObject(data: change.document.data()) { chat in
                            guard let chat = chat else { return }
                            completion(.success(ChatChange.modified(chat)))
                        }
                    default:
                        break
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func createChat(recipient: User, completion: @escaping (Result<Chat, Error>) -> Void) {
        let chat = Chat(id: UUID().uuidString, lastUpdateAt: Date(), recipient: recipient)
        firebaseFirestoreWrapper.setData(
            ref: db.collection(collectionName).document(chat.id),
            data: chatDataMapper.toData(object: chat)
        ) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(chat))
            }
        }
    }

    func getChat(for users: [User], completion: @escaping (Result<Chat, Error>) -> Void) {
        let membersIds = users.map { $0.uid }

        firebaseFirestoreWrapper.getDocument(
            db.collection(collectionName)
                .whereField("membersIds.\(membersIds.first!)", isEqualTo: true)
                .whereField("membersIds.\(membersIds.last!)", isEqualTo: true)
        ) { [weak self] result in
            switch result {
            case .success(let snapshot):
                self?.chatDataMapper.toObject(data: snapshot.data()) { chat in
                    if let chat = chat {
                        completion(.success(chat))
                    } else {
                        completion(.failure(ChatStorageError.cantDecodeChatData(
                            "Can't decode chat data for \(membersIds)"
                        )))
                    }
                }
            case .failure(let error):
                switch error {
                case FirebaseError.documentNotFound :
                    completion(.failure(
                        ChatStorageError.chatNotFound("Chat for members \(membersIds) not found")
                    ))
                default:
                    completion(.failure(error))
                }
            }
        }
    }

    func getChats(for user: User, completion: @escaping (Result<[Chat], Error>) -> Void) {
        print("CALL getChats for user:", user)
        firebaseFirestoreWrapper.getDocuments(
            db.collection(collectionName).whereField("membersIds.\(user.uid)", isEqualTo: true)
        ) { result in
            switch result {
            case .success(let documents):
                let dispatchGroup = DispatchGroup()
                var chats: [Chat] = []

                documents.forEach { [weak self] snapshot in
                    dispatchGroup.enter()
                    self?.chatDataMapper.toObject(data: snapshot.data()) { chat in
                        if let chat = chat {
                            chats.append(chat)
                        }

                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    print("RETURN CHATS", chats.count)
                    chats.sort { $0.lastUpdateAt > $1.lastUpdateAt }
                    completion(.success(chats))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func setLastMessage(chat: Chat, message: Message, completion: @escaping (Error?) -> Void) {
        do {
            firebaseFirestoreWrapper.updateData(
                ref: db.collection(collectionName).document(chat.id),
                data: [
                    "lastUpdateAt": message.sentDate,
                    "lastMessageKind": try DictionaryEncoder().encode(message.kind)
                ],
                completion: completion
            )
        } catch {
            completion(error)
        }
    }
 }
