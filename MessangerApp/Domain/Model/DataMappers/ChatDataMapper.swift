//
//  ChatDataMapper.swift
//  MessangerApp
//
//  Created by andy on 27.11.2021.
//

import FirebaseFirestore
import MessageKit

class ChatDataMapper: DataMapper<[String: Any], Chat> {
    private let currentUserId: String
    private let userProfile: UserProfileProtocol

    init(userProfile: UserProfileProtocol, userSession: UserSessionProtocol) {
        self.currentUserId = userSession.user!.uid
        self.userProfile = userProfile
    }

    override func toObject(data: [String: Any], completion: @escaping (Chat?) -> Void) {
        guard
            let id = data["id"] as? String,
            let lastUpdateAtTimestamp = data["lastUpdateAt"] as? Timestamp,
            let recipientId = (data["membersIds"] as? [String: Bool])?.first(where: { $0.key != currentUserId })?.key
        else {
            completion(nil)
            return
        }

        var lastMessageKind: MessageKind?

        if data["lastMessageKind"] != nil {
            lastMessageKind = try? DictionaryDecoder().decode(
                MessageKind.self,
                from: data["lastMessageKind"] as! [String: Any]
            )
        }

        userProfile.get(recipientId) { recipient in
            guard let recipient = recipient else {
                completion(nil)
                return
            }

            completion(
                Chat(
                    id: id,
                    lastUpdateAt: lastUpdateAtTimestamp.dateValue(),
                    recipient: recipient,
                    lastMessageKind: lastMessageKind
                )
            )
        }
    }

    override func toData(object: Chat) -> [String: Any] {
        [
            "id": object.id,
            "lastUpdateAt": object.lastUpdateAt,
            "membersIds": [
                currentUserId: true,
                object.recipient.uid: true
            ]
        ]
    }
}
