//
//  MessagesDisplayDelegate.swift
//  MessangerApp
//
//  Created by andy on 18.11.2021.
//

import MessageKit
import SDWebImage

extension ChatViewController: MessagesDisplayDelegate {
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        .label
    }

    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        isFromCurrentSender(message: message) ? UIColor.outgoingMessageBackground : incoming
        isFromCurrentSender(message: message) ? .init(hex: 0xe1fec6) : .white
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubbleTail(
            isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft,
            .pointedEdge
        )
    }

    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .photo(let mediaItem):
            if let url = mediaItem.url {
                imageView.sd_setImage(with: url)
            }
        case .video(let mediaItem):
            if let url = mediaItem.url {
                imageView.sd_setImage(with: url)
            }
        default:
            break
        }
    }

//    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        switch message.kind {
//        case .emoji:
//            return .clear
//        default:
//            guard let dataSource = messagesCollectionView.messagesDataSource else {
//                return .white
//            }
//            return dataSource.isFromCurrentSender(message: message) ? .white : .red
//        }
//    }

//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        avatarView.initials = nil
//    }
}
