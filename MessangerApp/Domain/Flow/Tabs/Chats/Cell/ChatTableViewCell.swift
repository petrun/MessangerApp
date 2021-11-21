import Then
import SnapKit

private extension Style {
    enum ChatTableViewCell {
        static var profileImageSize: CGSize { .init(width: 58, height: 58) }
        static var usernameLabelFont: UIFont { Fonts.headingTwo }
        static var descriptionLabelFont: UIFont { Fonts.headingThree }
    }
}

final class ChatTableViewCell: UITableViewCell {
    // MARK: - Properties

    lazy var profileImageView = UIImageView().then {
        $0.layer.cornerRadius = style.profileImageSize.height / 2
    }

    lazy var usernameLabel = UILabel().then {
        $0.font = style.usernameLabelFont
    }

    lazy var descriptionLabel = UILabel().then {
        $0.font = style.descriptionLabelFont
    }

    private lazy var stack = UIStackView().then { stack in
        stack.axis = .vertical
        stack.spacing = Style.Spacers.space1
        stack.distribution = .fill
        [
            usernameLabel,
            descriptionLabel
        ].forEach { stack.addArrangedSubview($0) }
    }

    private let style = Style.ChatTableViewCell.self
    private var chat: Chat!

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        add {
            profileImageView
            stack
        }

        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(16)
            make.size.equalTo(self.style.profileImageSize)
        }

        stack.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(profileImageView.snp.right).offset(16)
            make.right.equalTo(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(chat: Chat) {
        self.chat = chat
    }
}
