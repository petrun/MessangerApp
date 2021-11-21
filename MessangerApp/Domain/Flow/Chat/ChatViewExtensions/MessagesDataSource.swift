//
//  MessagesDataSource.swift
//  MessangerApp
//
//  Created by andy on 18.11.2021.
//

import MessageKit

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        viewModel.currentSender
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        viewModel.messageForItem(at: indexPath)
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        viewModel.messagesCount
    }

    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        guard indexPath.section % 3 == 0 else { return nil }

        let showLoadMore = false // (indexPath.section == 0 && viewModel.messagesCount > chat.totalMessages)
        let text = showLoadMore ? "Pull to load more" : MessageKitDateFormatter.shared.string(from: message.sentDate)
        let font = showLoadMore ? UIFont.systemFont(ofSize: 13) : UIFont.boldSystemFont(ofSize: 10)
        let color = showLoadMore ? UIColor.systemBlue : UIColor.darkGray

        return NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color
            ]
        )
    }

    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section != viewModel.messagesCount - 1 {
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            return NSAttributedString(
                string: message.sentDate.time(),
                attributes: [
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.foregroundColor: color
                ]
            )
        }
        return nil
    }

//    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        if isFromCurrentSender(message: message) {
//            let message = viewModel.messageForItem(at: indexPath)
//            let status = indexPath.section == viewModel.messagesCount - 1 ? "\(message.status) \(message.readDate.time())" : ""
//
//            return NSAttributedString(
//                string: status,
//                attributes: [
//                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
//                    NSAttributedString.Key.foregroundColor: UIColor.darkGray
//                ]
//            )
//        }
//    }
}
