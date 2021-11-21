//
//  MessageKind+Extension.swift
//  MessangerApp
//
//  Created by andy on 18.11.2021.
//

import MessageKit

extension MessageKind {
    var typeName: String {
        switch self {
        case .text:
            return "text"
        case .photo:
            return "photo"
        default:
            return "other"
        }
    }

    var content: String {
        switch self {
        case .text(let text):
            return text
        case .photo(let photo):
            return photo.url?.absoluteString ?? ""
        default:
            return ""
        }
    }
}
