//
//  MessageCellDelegate.swift
//  MessangerApp
//
//  Created by andy on 18.11.2021.
//

import AVKit
import MessageKit
import SDWebImage
import SKPhotoBrowser

extension ChatViewController: MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard
            let indexPath = messagesCollectionView.indexPath(for: cell),
            let messagesDataSource = messagesCollectionView.messagesDataSource
        else { return }

        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        switch message.kind {
        case .photo(let mediaItem):
            guard let url = mediaItem.url else { break }

            // TODO: NEED FIX Падает при выборе скриншота
            UIImageView().sd_setImage(with: url) { [weak self] image, _, _, _ in
                guard let self = self, let image = image else { return }

                self.present(
                    SKPhotoBrowser(photos: [SKPhoto.photoWithImage(image)]),
                    animated: true
                )
            }
        case .video(let mediaItem):
            guard
                let videoItem = mediaItem as? VideoMediaItem,
                let videoUrl = videoItem.videoUrl
            else { break }

            let playerViewController = AVPlayerViewController()
            playerViewController.player = AVPlayer(url: videoUrl)
            present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        default:
            break
        }
    }
}
