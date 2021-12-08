import Then
import SnapKit

private extension Style {
    enum ChatTableViewCell {
        static var profileImageSize: CGSize { .init(width: 52, height: 52) }
        static var usernameLabelFont: UIFont { FontFamily.SFProText.semibold.font(size: 16) }
        static var descriptionLabelFont: UIFont { FontFamily.SFProText.regular.font(size: 14) }
        static var dateLabelFont: UIFont { FontFamily.SFProText.regular.font(size: 14) }

        // unreadCount
        static var unreadCountViewBackgroundColor: UIColor { .init(hex: 0x037EE5) }
        static var unreadCountViewFont: UIFont { FontFamily.SFProText.regular.font(size: 14) }
        static var unreadCountViewSize: CGSize { .init(width: 26, height: 20) }
        static var unreadCountViewTextColor: UIColor { .white }
    }
}

final class ChatTableViewCell: UITableViewCell {
    // MARK: - View properties

    private lazy var profileImageView = UIImageView().then {
        $0.layer.cornerRadius = style.profileImageSize.height / 2
    }

    private lazy var usernameLabel = UILabel().then {
        $0.font = style.usernameLabelFont
    }

    private lazy var descriptionLabel = UILabel().then {
        $0.font = style.descriptionLabelFont
        $0.numberOfLines = 2
    }

    private lazy var dateLabel = UILabel().then {
        $0.font = style.dateLabelFont
        $0.tintColor = .lightGray
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    private lazy var unreadCountView = UIView().then {
        $0.backgroundColor = style.unreadCountViewBackgroundColor
        $0.layer.cornerRadius = style.unreadCountViewSize.height / 2
    }

    private lazy var unreadCountLabel = UILabel().then {
        $0.font = style.unreadCountViewFont
        $0.textColor = style.unreadCountViewTextColor
    }

    // MARK: - Properties

    private let style = Style.ChatTableViewCell.self

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        add {
            profileImageView
            usernameLabel
            dateLabel
            descriptionLabel
            unreadCountView
        }

        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(Style.Spacers.space1)
            make.size.equalTo(self.style.profileImageSize)
        }

        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(Style.Spacers.space1)
            make.left.equalTo(profileImageView.snp.right).offset(Style.Spacers.space1)
            make.right.lessThanOrEqualTo(dateLabel.snp.left).offset(-Style.Spacers.space1)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(Style.Spacers.space1)
            make.right.equalTo(-Style.Spacers.space1)
        }

        unreadCountView.snp.makeConstraints { make in
            make.size.equalTo(self.style.unreadCountViewSize)
            make.right.equalTo(-Style.Spacers.space1)
            make.bottom.equalTo(-Style.Spacers.space2)
        }

        unreadCountView.add {
            unreadCountLabel
        }

        unreadCountLabel.snp.makeConstraints { make in
            make.center.equalTo(unreadCountView)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(Style.Spacers.space1)
            make.top.equalTo(usernameLabel.snp.bottom).offset(1)
            make.right.lessThanOrEqualTo(unreadCountView.snp.left).offset(-Style.Spacers.space2)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(chat: Chat) {
        profileImageView.image = Asset.avatar.image
        usernameLabel.text = chat.title ?? "Empty chat name"
        descriptionLabel.text = chat.lastMessageKind?.previewText
        dateLabel.text = chat.lastUpdateAt.timeElapsed()

        unreadCountView.isHidden = true
//        unreadCountLabel.text = "1"
    }
}
