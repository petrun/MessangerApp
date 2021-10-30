//
//  UIButton+Extension.swift
//  MessangerApp
//
//  Created by andy on 30.10.2021.
//

import Then
import SnapKit
import UIKit

extension UIButton {
    static func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        UIButton(type: .system).then {
            let attributedTitle = NSMutableAttributedString(string: "\(firstPart) ", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ])

            attributedTitle.append(NSAttributedString(string: secondPart, attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]))

            $0.setAttributedTitle(attributedTitle, for: .normal)
        }
    }

    static func submitButton(title: String) -> UIButton {
        UIButton(type: .system).then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(Constants.twitterBlue, for: .normal)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 5
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
        }
    }
}
