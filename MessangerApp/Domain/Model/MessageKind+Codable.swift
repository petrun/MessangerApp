//
//  MessageKind+Extension.swift
//  MessangerApp
//
//  Created by andy on 20.11.2021.
//

import Firebase
import FirebaseFirestoreSwift
import MessageKit

extension MessageKind: Codable {
    enum CodingError: Error {
        case emptyValue
        case unknownMessageKindType(String)
        case unknownValue
    }

    private enum CodingKeys: CodingKey {
        case content
        case type
    }

    private enum MessageKindType: String {
        case photo
        case text
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch MessageKindType(rawValue: type) {
        case .text:
            let text = try container.decode(String.self, forKey: .content)
            self = .text(text)
        case .photo:
            let imageUrlString = try container.decode(String.self, forKey: .content)
            guard let imageUrl = URL(string: imageUrlString) else {
                throw CodingError.emptyValue
            }
            self = .photo(ImageMediaItem(imageURL: imageUrl))
        default:
            throw CodingError.unknownMessageKindType(type)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let text):
            try container.encode(MessageKindType.text.rawValue, forKey: .type)
            try container.encode(text, forKey: .content)
        case .photo(let photo):
            try container.encode(MessageKindType.photo.rawValue, forKey: .type)
            try container.encode(photo.url?.absoluteString, forKey: .content)
        default:
            throw CodingError.unknownValue
        }
    }
}