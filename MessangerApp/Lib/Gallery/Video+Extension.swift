//
//  Video+Extension.swift
//  MessangerApp
//
//  Created by andy on 22.11.2021.
//

import Gallery
import Photos

extension Video {
    /// Генерация превью, в отличие от fetchThumbnail вызывает completion только когда будет сгенерированно конечное превью
    func generateThumbnail(size: CGSize = CGSize(width: 240, height: 240), completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: options
        ) { image, keys in
            guard keys?["PHImageResultIsDegradedKey"] as! Int == 0 else { return }

            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
