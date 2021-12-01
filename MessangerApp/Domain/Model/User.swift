//
//  User.swift
//  MessangerApp
//
//  Created by andy on 12.11.2021.
//

import MessageKit

struct User: Codable {
    let uid: String
    let name: String
    var createdAt: Date
    var profileImageUrl: URL?
}

extension User: SenderType {
    var senderId: String { uid }
    var displayName: String { name }
}
