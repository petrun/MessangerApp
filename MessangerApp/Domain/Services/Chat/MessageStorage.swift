//
//  MessageStorage.swift
//  MessangerApp
//
//  Created by andy on 19.11.2021.
//

import FirebaseFirestore
import MessageKit

protocol MessageStorageProtocol {
    func getMessages(
        chat: Chat,
        limit: Int,
        beforeMessage: Message?,
        completion: @escaping (Result<[Message], Error>) -> Void
    )

    func listenForNewMessages(
        chat: Chat,
        lastMessage: Message?,
        completion: @escaping (Result<Message, Error>) -> Void
    ) -> ListenerRegistration

    func sendMessage(
        chat: Chat,
        sender: User,
        kind: MessageKind,
        completion: @escaping (Result<Message, Error>) -> Void
    )
}

final class MessageStorage {
    private lazy var db = Firestore.firestore()
    private let collectionName = "messages"
    private let firebaseFirestoreWrapper: FirebaseFirestoreWrapperProtocol
    private let messageDataMapper: MessageDataMapper

    init(
        firebaseFirestoreWrapper: FirebaseFirestoreWrapperProtocol,
        messageDataMapper: MessageDataMapper
    ) {
        self.firebaseFirestoreWrapper = firebaseFirestoreWrapper
        self.messageDataMapper = messageDataMapper
    }
}

extension MessageStorage: MessageStorageProtocol {
    func getMessages(
        chat: Chat,
        limit: Int,
        beforeMessage: Message?,
        completion: @escaping (Result<[Message], Error>) -> Void
    ) {
        var query = db.collection(collectionName)
            .document(chat.id)
            .collection("messages")
            .order(by: "sentDate", descending: true)
            .limit(to: limit)

        if let beforeMessage = beforeMessage {
            // Время последнего сообщения - 1 сек.
            // Если просто прокидывать sentDate, то дает получает дубли
            query = query.whereField(
                "sentDate",
                isLessThan: Calendar.current.date(byAdding: .second, value: -1, to: beforeMessage.sentDate)!
            )
        }

        firebaseFirestoreWrapper.getDocuments(query) { result in
            switch result {
            case .success(let documents):
                let dispatchGroup = DispatchGroup()
                var messages: [Message] = []

                documents.reversed().forEach { [weak self] snapshot in
                    dispatchGroup.enter()
                    self?.messageDataMapper.toObject(data: snapshot.data()) { message in
                        if let message = message {
                            messages.append(message)
                        }

                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    print("RETURN MESSAGES", messages.count)
                    messages.sort { $0.sentDate < $1.sentDate }
                    completion(.success(messages))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func listenForNewMessages(
        chat: Chat,
        lastMessage: Message?,
        completion: @escaping (Result<Message, Error>) -> Void
    ) -> ListenerRegistration {
        firebaseFirestoreWrapper.addListener(
            query: db.collection(collectionName)
                .document(chat.id)
                .collection("messages")
                .whereField("sentDate", isGreaterThan: lastMessage?.sentDate ?? Date())
        ) { [weak self] result in
            switch result {
            case .success(let documentChanges):
                for change in documentChanges {
                    switch change.type {
                    case .added:
                        self?.messageDataMapper.toObject(data: change.document.data()) { message in
                            guard let message = message else { return }

                            print("Added new message \(message)")
                            completion(.success(message))
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

    func sendMessage(
        chat: Chat,
        sender: User,
        kind: MessageKind,
        completion: @escaping (Result<Message, Error>) -> Void
    ) {
        let message = Message(messageId: UUID().uuidString, sender: sender, sentDate: Date(), kind: kind)

        do {
            firebaseFirestoreWrapper.setData(
                ref: db.collection(collectionName)
                    .document(chat.id)
                    .collection("messages")
                    .document(message.messageId),
                data: try messageDataMapper.toData(object: message)
            ) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(message))
                }
            }

            // TODO: Send notification
            // TODO: Update chat unview count
        } catch {
            completion(.failure(error))
        }
    }
}
