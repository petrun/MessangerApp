//
//  VideoMediaItem.swift
//  MessangerApp
//
//  Created by andy on 22.11.2021.
//

import MessageKit
import UIKit

struct VideoMediaItem: MediaItem, Codable {
    var url: URL?
    var image: UIImage?
    var placeholderImage = UIImage()
    var size = CGSize(width: 240, height: 240)
    var videoUrl: URL?

    init(thumbUrl: URL, videoUrl: URL) {
        self.url = thumbUrl
        self.videoUrl = videoUrl
    }

    enum CodingKeys: CodingKey {
        case url
        case videoUrl
    }
}
