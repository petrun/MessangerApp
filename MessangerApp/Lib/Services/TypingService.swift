//
//  TypingService.swift
//  MessangerApp
//
//  Created by andy on 21.11.2021.
//

import FirebaseFirestore

protocol TypingServiceProtocol {
    func createTypingObserver(
        chatId: String,
        currentUserId: String,
        completion: @escaping (_ isTyping: Bool) -> Void
    ) -> ListenerRegistration
    func set(typing: Bool, chatId: String, userId: String)
}

final class TypingService {
    private lazy var db = Firestore.firestore()
    private let collectionName = "typing"
}

extension TypingService: TypingServiceProtocol {
    func createTypingObserver(
        chatId: String,
        currentUserId: String,
        completion: @escaping (_ isTyping: Bool) -> Void
    ) -> ListenerRegistration {
        db.collection(collectionName)
            .document(chatId)
            .addSnapshotListener { [weak self] documentSnapshot, error in
                if let error = error {
                    print("Error createTypingObserver", error.localizedDescription)
                }

                guard
                    let self = self,
                    let snapshot = documentSnapshot
                else { return }

                if snapshot.exists {
                    for data in snapshot.data()! where data.key != currentUserId {
                        completion(data.value as! Bool)
                    }
                } else {
                    completion(false)
                    self.db.collection(self.collectionName)
                        .document(chatId)
                        .setData([currentUserId: false])
                }
            }
    }

    func set(typing: Bool, chatId: String, userId: String) {
        db.collection(collectionName)
            .document(chatId)
            .updateData([userId: typing])
    }
}
