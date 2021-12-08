import Gallery
import InputBarAccessoryView
import MessageKit
import Then

private extension Style {
    enum ChatViewController {
        static var inputBarButtonItemSize: CGSize { .init(width: 30, height: 30) }
    }
}

class ChatViewController: MessagesViewController {
    let refreshController = UIRefreshControl()
    var viewModel: ChatViewModelProtocol!

    private let style = Style.ChatViewController.self

    lazy var micButton = InputBarButtonItem().then {
        $0.image = UIImage(
            systemName: "mic",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: style.inputBarButtonItemSize.height,
                weight: .regular
            )
        )?.withRenderingMode(.alwaysOriginal)
        $0.setSize(style.inputBarButtonItemSize, animated: false)
        $0.onTouchUpInside { _ in
            print("mic button pressed")
        }
    }

    private lazy var attachButton = InputBarButtonItem().then {
        $0.image = UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: style.inputBarButtonItemSize.height,
                weight: .regular
            )
        )?.withRenderingMode(.alwaysOriginal)
        $0.setSize(style.inputBarButtonItemSize, animated: false)
        $0.onTouchUpInside { [weak self] _ in self?.attachButtonPressed() }
    }

    private lazy var leftBarButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50)).then {
        $0.add {
            titleLabel
            subTitleLabel
        }
    }

    private lazy var titleLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 180, height: 25)).then {
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.adjustsFontSizeToFitWidth = true
    }

    private lazy var subTitleLabel = UILabel(frame: CGRect(x: 5, y: 22, width: 180, height: 20)).then {
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 13, weight: .medium)
        $0.adjustsFontSizeToFitWidth = true
    }

    private lazy var avatarImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.image = Asset.avatar.image
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        configureNavigationBar()

        configureMessagesCollectionView()
        configureMessageInputBar()

        viewModel.start()
    }

    private func configureNavigationBar() {
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(backButtonPressed)
            ),
            UIBarButtonItem(customView: leftBarButtonView)
        ]

        titleLabel.text = viewModel.chatTitle

        // TODO: Add avatar view
    }

    private func configureMessagesCollectionView() {
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self

        messagesCollectionView.refreshControl = refreshController
        messagesCollectionView.backgroundView = UIImageView(image: Asset.background.image)

        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
    }

    private func configureMessageInputBar() {
        messageInputBar.delegate = self

        // LeftStackView
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)

        // RightStackView
        updateMicButtonStatus(show: true)

        // InputTextView
        messageInputBar.inputTextView.isImagePasteEnabled = false
    }

    private func configureSendButton() {
        messageInputBar.sendButton.setImage(Asset.Icons.comment.image, for: .normal)
        messageInputBar.sendButton.tintColor = .blue

        messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
        messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
        messageInputBar.middleContentViewPadding.right = -38
    }

    // MARK: - Actions

    @objc private func backButtonPressed() {
        viewModel.backButtonPressed()
    }

    private func attachButtonPressed() {
        messageInputBar.inputTextView.resignFirstResponder()

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(title: "Camera") { [weak self] _ in
            self?.showImageGallery(camera: true)
        }

        actionSheet.addAction(title: "Library") { [weak self] _ in
            self?.showImageGallery(camera: false)
        }

        actionSheet.addCancelAction(title: "Cancel")

        present(actionSheet, animated: true)
    }

    func updateMicButtonStatus(show: Bool) {
        if show {
            messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        } else {
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard refreshController.isRefreshing else { return }

        print("Call scrollViewDidEndDecelerating")
        viewModel.loadMoreMessages { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.messagesCollectionView.reloadDataAndKeepOffset()
                self?.refreshController.endRefreshing()
            }
        }
    }

    // MARK: - Gallery
    private func showImageGallery(camera: Bool) {
        let gallery = GalleryController()
        gallery.delegate = self

        Config.tabsToShow = camera ? [.cameraTab] : [.imageTab, .videoTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        Config.VideoEditor.maximumDuration = 30

        present(gallery, animated: true)
    }
}

extension ChatViewController: ChatViewModelDelegate {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            print("CALL ChatViewController:reloadData")
            self?.messagesCollectionView.reloadData()
            self?.messagesCollectionView.scrollToLastItem()
        }
    }

    func updateTypingIndicator(_ isTyping: Bool) {
        subTitleLabel.text = isTyping ? "Typing..." : ""
    }
}

extension ChatViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if !images.isEmpty {
            images.first!.resolve { [weak self] image in
                guard let self = self, let image = image else { return }

                self.viewModel.sendMessage(image: image)
            }
        }

        controller.dismiss(animated: true)
    }

    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        viewModel.sendMessage(video: video)

        controller.dismiss(animated: true)
    }

    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true)
    }

    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true)
    }
}
