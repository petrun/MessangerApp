//
//  AddPhotoContainer.swift
//  MessangerApp
//
//  Created by andy on 08.12.2021.
//

import Then
import SnapKit

class AddPhotoContainer: UIView {
    private let containerSize = CGSize(width: 150, height: 150)

    lazy var imagePicker = UIImagePickerController().then {
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
    }

    lazy var addPhotoButton = UIButton(type: .system).then {
        $0.setImage(Asset.plusPhoto.image, for: .normal)
        $0.tintColor = BaseColors.blue
        $0.imageView?.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }

    override func layoutIfNeeded() {
        print("CALL layoutIfNeeded")
        addPhotoButton.layer.cornerRadius = containerSize.height / 2
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)

        snp.makeConstraints { make in
            make.size.equalTo(containerSize)
        }

        addSubview(addPhotoButton)

        addPhotoButton.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.size.equalTo(containerSize)
        }
        addPhotoButton.layer.cornerRadius = containerSize.height / 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(_ image: UIImage) {
        addPhotoButton.setImage(image, for: .normal)
//        addPhotoButton.layer.borderColor = UIColor.white.cgColor
//        addPhotoButton.layer.borderWidth = 3

        print("CALL setImage")
    }
}
