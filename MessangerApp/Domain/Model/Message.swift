//
//  Message.swift
//  MessangerApp
//
//  Created by andy on 15.11.2021.
//

import MessageKit

struct Message: MessageType {
    let messageId: String
    let sender: SenderType
    let sentDate: Date
    let kind: MessageKind
}

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.messageId == rhs.messageId
    }
}
