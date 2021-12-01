//
//  MessageDataMapper.swift
//  MessangerApp
//
//  Created by andy on 27.11.2021.
//

import FirebaseFirestore
import MessageKit

class MessageDataMapper {
    private let userProfile: UserProfileProtocol

    init(userProfile: UserProfileProtocol) {
        self.userProfile = userProfile
    }

    func toObject(data: [String: Any], completion: @escaping (Message?) -> Void) {
        guard
            let messageId = data["messageId"] as? String,
            let kind = try? DictionaryDecoder().decode(MessageKind.self, from: data["kind"] as! [String: Any]),
            let senderId = data["senderId"] as? String,
            let sentDateTimestamp = data["sentDate"] as? Timestamp
        else {
            completion(nil)
            return
        }

        userProfile.get(senderId) { user in
            guard let user = user else {
                completion(nil)
                return
            }

            completion(
                Message(
                    messageId: messageId,
                    sender: user,
                    sentDate: sentDateTimestamp.dateValue(),
                    kind: kind
                )
            )
        }
    }

    func toData(object: Message) throws -> [String: Any] {
        [
            "messageId": object.messageId,
            "kind": try DictionaryEncoder().encode(object.kind),
            "senderId": object.sender.senderId,
            "sentDate": object.sentDate
        ]
    }
}
