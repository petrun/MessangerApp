//
//  Chat.swift
//  MessangerApp
//
//  Created by andy on 12.11.2021.
//

import MessageKit

struct Chat {
    let id: String
    let lastUpdateAt: Date
    let recipient: User
    let lastMessageKind: MessageKind?

    var title: String? {
        recipient.name
    }
    var imageUrl: URL? {
        recipient.profileImageUrl
    }

    init(id: String, lastUpdateAt: Date, recipient: User, lastMessageKind: MessageKind? = nil) {
        self.id = id
        self.lastUpdateAt = lastUpdateAt
        self.recipient = recipient
        self.lastMessageKind = lastMessageKind
    }
}
