//
//  ImageMediaItem.swift
//  MessangerApp
//
//  Created by andy on 18.11.2021.
//

import UIKit
import MessageKit

struct ImageMediaItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }

    init(imageURL: URL) {
        self.url = imageURL
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
//            UIImage(imageLiteralResourceName: "image_message_placeholder")
    }
}
