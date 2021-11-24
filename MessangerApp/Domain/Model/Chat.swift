//
//  Chat.swift
//  MessangerApp
//
//  Created by andy on 12.11.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum ChatType: Int, Codable {
    case privateChat
}

struct Chat {
    @DocumentID var id: String? = UUID().uuidString
    @ServerTimestamp var createdAt = Date()
    @ServerTimestamp var lastUpdateAt = Date()
    var type: ChatType
    var membersIds: [String]
    var title: String?
    var imageUrl: URL?
//    var lastMessage: Message?
}

extension Chat: Codable {
    private var boolMembersIds: [String: Bool] {
        membersIds.reduce(into: [:]) { result, userId in
            result[userId] = true
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt
        case lastUpdateAt
        case type
        case membersIds
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        createdAt = try values.decode(Date.self, forKey: .createdAt)
        lastUpdateAt = try values.decode(Date.self, forKey: .lastUpdateAt)
        type = try values.decode(ChatType.self, forKey: .type)
        membersIds = try values.decode([String: Bool].self, forKey: .membersIds).map { $0.key }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(lastUpdateAt, forKey: .lastUpdateAt)
        try container.encode(type, forKey: .type)
        try container.encode(boolMembersIds, forKey: .membersIds)
    }
}
