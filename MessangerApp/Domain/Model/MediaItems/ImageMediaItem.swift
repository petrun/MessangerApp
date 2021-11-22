//
//  ImageMediaItem.swift
//  MessangerApp
//
//  Created by andy on 18.11.2021.
//

import MessageKit
import UIKit

struct ImageMediaItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage = UIImage()
    var size = CGSize(width: 240, height: 240)

    init(imageURL: URL) {
        self.url = imageURL
    }
}
