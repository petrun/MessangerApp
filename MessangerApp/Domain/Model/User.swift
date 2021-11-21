//
//  User.swift
//  MessangerApp
//
//  Created by andy on 12.11.2021.
//

import FirebaseFirestoreSwift
import Firebase

struct User: Codable {
    let uid: String
    let name: String
    @ServerTimestamp var createdAt: Timestamp?
    var profileImageUrl: URL?
    var status: String?

    var sender: Sender { .init(senderId: uid, displayName: name) }
}
