//
//  MessagesLayoutDelegate.swift
//  MessangerApp
//
//  Created by andy on 18.11.2021.
//

import MessageKit

extension ChatViewController: MessagesLayoutDelegate {
//    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
//        CGSize(width: 0, height: 8)
//    }

    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        if indexPath.section == 0 && viewModel.messagesCount > chat.totalMessages {
//            return 40
//        }

        indexPath.section % 3 == 0 ? 18 : 0
    }

    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        isFromCurrentSender(message: message) ? 17 : 0
    }

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        indexPath.section != viewModel.messagesCount - 1 ? 10 : 0
    }

//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        avatarView.set(avatar: Avatar(initials: viewModel.messageForItem(at: indexPath).ini))
//    }
}
