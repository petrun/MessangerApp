import SnapKit

class InputContainerWithValidation: UIView {
    let errorLabel = UILabel().then {
        $0.textColor = UIColor.red
        $0.font = Style.Fonts.sub
        $0.isHidden = true
    }
    let textField: UITextField

    private lazy var stack = UIStackView().then { stack in
        stack.axis = .vertical
        stack.spacing = 2
        stack.distribution = .fill
        [
            textField,
            errorLabel
        ].forEach { stack.addArrangedSubview($0) }
    }

    init(textField: UITextField) {
        self.textField = textField

        super.init(frame: .zero)

        addSubview(stack)

        stack.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }

//        showError(message: "test error")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    func showError(message: String) {
//        errorLabel.text = message
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.red.cgColor
//    }
//
//    func hideError() {
//        errorLabel.text = nil
//        textField.layer.borderWidth = 0
//    }
}
