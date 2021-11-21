//
//  Message.swift
//  MessangerApp
//
//  Created by andy on 15.11.2021.
//

import Firebase
import FirebaseFirestoreSwift
import MessageKit

struct Message: MessageType {
//    let id: String?
    var messageId: String  // { id ?? UUID().uuidString }
    let sender: SenderType
    let sentDate: Date
    let kind: MessageKind

//    var status: String = "Unread"
//    var readDate: Date

    init(
        sender: SenderType,
        kind: MessageKind
    ) {
        messageId = UUID().uuidString
        self.sender = sender
        self.kind = kind
        self.sentDate = Date()
    }
}

//extension Message: Equatable {
//    static func == (lhs: Message, rhs: Message) -> Bool {
//        lhs.messageId == rhs.messageId
//    }
//}

extension Message: Codable {
    private enum CodingKeys: String, CodingKey {
        case messageId
        case sentDate
        case kind

        case senderId
        case displayName
    }

    private enum CodingError: Error {
        case emptyValue
        case unknownMessageKindType(String)
        case unknownValue
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        messageId = try values.decode(String.self, forKey: .messageId)
        sentDate = try values.decode(Date.self, forKey: .sentDate)
        kind = try values.decode(MessageKind.self, forKey: .kind)

        sender = Sender(
            senderId: try values.decode(String.self, forKey: .senderId),
            displayName: try values.decode(String.self, forKey: .displayName)
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(messageId, forKey: .messageId)
        try container.encode(sentDate, forKey: .sentDate)
        try container.encode(kind, forKey: .kind)

        try container.encode(sender.senderId, forKey: .senderId)
        try container.encode(sender.displayName, forKey: .displayName)
    }
}
