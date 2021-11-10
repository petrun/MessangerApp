//
//  ChatViewController.swift
//  MessangerApp
//
//  Created by andy on 07.11.2021.
//

import InputBarAccessoryView
import MessageKit

struct Sender: SenderType {
    let senderId: String
    let displayName: String
}

struct Chat {
}

struct MessageItem: MessageType {
    let sender: SenderType
    let messageId: String
    let sentDate: Date
    let kind: MessageKind
}


class ChatViewController: MessagesViewController {
    let sender = Sender(senderId: "any_unique_id", displayName: "Andy")
    // receiver
    var messages: [MessageType] = []

//    private let chat: Chat
//
//    init(sender: Sender, chat: Chat) {
//        self.chat = chat
//
//        super.init(nibName: nil, bundle: nil)
//    }

//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        messagesCollectionView.backgroundColor = .lightGray

        title = "Friend username"

//        configureMessageInputBar()
    }

    func configureMessageInputBar() {
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = UIColor.white
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
        messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 0.4033635232)
        messageInputBar.inputTextView.layer.borderWidth = 0.2
        messageInputBar.inputTextView.layer.cornerRadius = 18.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)

//        messageView.textView.placeholderText = "New message..."
//        messageView.textView.placeholderTextColor = .lightGray

        messageInputBar.inputTextView.placeholderLabel.text = "New message..."


        messageInputBar.inputTextView.layer.backgroundColor = UIColor.green.cgColor
        messageInputBar.rightStackView.layer.backgroundColor = UIColor.red.cgColor


        messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageInputBar.layer.shadowRadius = 5
        messageInputBar.layer.shadowOpacity = 0.3
        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)

        configureSendButton()
    }

    func configureSendButton() {
        messageInputBar.sendButton.setImage(Asset.Icons.comment.image, for: .normal)
        messageInputBar.sendButton.tintColor = .blue

//        messageInputBar.sendButton.applyGradients(cornerRadius: 10)
        messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
        messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
        messageInputBar.middleContentViewPadding.right = -38
    }

    private func insertNewMessage(message: MessageType) {
//        guard !messages.contains(where: message) else { return }

        messages.append(message)
        messagesCollectionView.reloadData()
    }
}

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        sender
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
}

extension ChatViewController: MessagesLayoutDelegate {
//    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
//        CGSize(width: 0, height: 8)
//    }
}

extension ChatViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        .red


        switch message.kind {
        case .emoji:
            return .clear
        default:
            guard let dataSource = messagesCollectionView.messagesDataSource else {
                return .white
            }
//            return dataSource.isFromCurrentSender(message: message) ? .outgoingMessageBackground : .incomingMessageBackground
            return dataSource.isFromCurrentSender(message: message) ? .white : .red
        }
    }

    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        .blue
    }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        avatarView.frame = .zero
        avatarView.initials = nil
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        .bubble
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MessageItem(
            sender: sender,
            messageId: UUID().uuidString,
            sentDate: Date(),
            kind: MessageKind.text(text)
        )
        insertNewMessage(message: message)
        inputBar.inputTextView.text = ""
    }

//    /// Called when the default send button has been selected
//    ///
//    /// - Parameters:
//    ///   - inputBar: The InputBarAccessoryView
//    ///   - text: The current text in the InputBarAccessoryView's InputTextView
//    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String)
//
//    /// Called when the instrinsicContentSize of the InputBarAccessoryView has changed. Can be used for adjusting content insets
//    /// on other views to make sure the InputBarAccessoryView does not cover up any other view
//    ///
//    /// - Parameters:
//    ///   - inputBar: The InputBarAccessoryView
//    ///   - size: The new instrinsicContentSize
//    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize)
//
//    /// Called when the InputBarAccessoryView's InputTextView's text has changed. Useful for adding your own logic without the
//    /// need of assigning a delegate or notification
//    ///
//    /// - Parameters:
//    ///   - inputBar: The InputBarAccessoryView
//    ///   - text: The current text in the InputBarAccessoryView's InputTextView
//    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String)
//
//    /// Called when a swipe gesture was recognized on the InputBarAccessoryView's InputTextView
//    ///
//    /// - Parameters:
//    ///   - inputBar: The InputBarAccessoryView
//    ///   - gesture: The gesture that was recognized
//    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer)
}
