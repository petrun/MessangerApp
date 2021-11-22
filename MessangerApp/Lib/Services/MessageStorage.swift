//
//  MessageStorage.swift
//  MessangerApp
//
//  Created by andy on 19.11.2021.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import MessageKit

protocol MessageStorageProtocol {
    func getMessages(
        chat: Chat,
        limit: Int,
        beforeMessage: MessageType?,
        completion: @escaping (Result<[MessageType], Error>) -> Void
    )
    func listenForNewMessages(
        chat: Chat,
        lastMessage: MessageType?,
        completion: @escaping (Result<MessageType, Error>) -> Void
    )
    func sendMessage(chat: Chat, message: Message)
}

final class MessageStorage {
    private lazy var db = Firestore.firestore()
    private let collectionName = "messages"
}

extension MessageStorage: MessageStorageProtocol {
    func getMessages(
        chat: Chat,
        limit: Int,
        beforeMessage: MessageType?,
        completion: @escaping (Result<[MessageType], Error>) -> Void
    ) {
        guard let chatId = chat.id else {
            print("ChatId is empty")
            return
        }

        var query = db.collection(collectionName)
            .document(chatId)
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

        query
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                }

                guard let documents = querySnapshot?.documents else {
                    print("No messages")
                    completion(.success([]))
                    return
                }

                completion(.success(
                    documents.reversed().compactMap { try? $0.data(as: Message.self) }
                ))
            }
    }

    func listenForNewMessages(
        chat: Chat,
        lastMessage: MessageType?,
        completion: @escaping (Result<MessageType, Error>) -> Void
    ) {
        guard let chatId = chat.id else {
            print("ChatId is empty")
            return
        }

        db.collection(collectionName)
            .document(chatId)
            .collection("messages")
            .whereField("sentDate", isGreaterThan: lastMessage?.sentDate ?? Date())
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let snapshot = querySnapshot else { return }

                for change in snapshot.documentChanges {
                    switch change.type {
                    case .added:
                        guard let message = try? change.document.data(as: Message.self) else {
                            return
                        }

                        print("Added new message \(message)")

                        completion(.success(message))
                    case .modified:
                        break
                    case .removed:
                        break
                    }
                }
            }
    }

    func sendMessage(chat: Chat, message: Message) {
        guard let chatId = chat.id else {
            print("ChatId is empty")
            return
        }

        do {
            try firebaseReference(.messages)
                .document(chatId)
                .collection("messages")
                .document(message.messageId)
                .setData(from: message)

            // TODO: Send notification
            // TODO: Update chatLastMessage
            // TODO: Update chat unview count
        } catch {
            print(error.localizedDescription)
        }
    }
}
