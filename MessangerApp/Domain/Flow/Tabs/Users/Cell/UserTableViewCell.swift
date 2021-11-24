import Then
import SnapKit

private extension Style {
    enum UserTableViewCell {
        static var profileImageSize: CGSize { .init(width: 40, height: 40) }
        static var usernameLabelFont: UIFont { FontFamily.SFProText.medium.font(size: 17) }
        static var onlineLabelFont: UIFont { FontFamily.SFProText.regular.font(size: 13) }
        static var isNotOnlineColor: UIColor { .init(hex: 0x7E7E82) }
        static var isOnlineColor: UIColor { .init(hex: 0x037EE5) }
    }
}

final class UserTableViewCell: UITableViewCell {
    // MARK: - View properties

    lazy var profileImageView = UIImageView().then {
        $0.layer.cornerRadius = style.profileImageSize.height / 2
    }

    lazy var usernameLabel = UILabel().then {
        $0.font = style.usernameLabelFont
    }

    lazy var onlineLabel = UILabel().then {
        $0.font = style.onlineLabelFont
    }

    // MARK: - Properties

    private let style = Style.UserTableViewCell.self

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        add {
            profileImageView
            usernameLabel
            onlineLabel
        }

        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(Style.Spacers.space2)
            make.size.equalTo(self.style.profileImageSize)
        }

        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.left.equalTo(profileImageView.snp.right).offset(Style.Spacers.space1)
            make.right.equalTo(self).offset(-Style.Spacers.space1)
        }

        onlineLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(Style.Spacers.space1)
            make.top.equalTo(usernameLabel.snp.bottom).offset(1)
            make.right.equalTo(self).offset(-Style.Spacers.space1)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(user: User) {
        profileImageView.image = Asset.avatar.image
        usernameLabel.text = user.name
//        onlineLabel.text = "last seen 1 hour ago"
        setOnline(isOnline: false, lastVisitDate: Date())
    }

    private func setOnline(isOnline: Bool, lastVisitDate: Date) {
        if isOnline {
            onlineLabel.textColor = style.isOnlineColor
            onlineLabel.text = "online"
        } else {
            onlineLabel.textColor = style.isNotOnlineColor
            onlineLabel.text = "last seen 1 hour ago"
        }
    }
}
