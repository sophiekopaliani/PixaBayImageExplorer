//
//  TextFieldView.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import UIKit

public class TextFieldView: UIView {
    
    var model: TextFieldModel? {
        didSet { self.configure(model: model) }
    }
    
    var inputState: TextFieldState = .inactive {
        didSet { configureBackground(for: inputState) }
    }
    
    var isSecurityDisabled: Bool = false {
        didSet { configure(model: model) }
    }
    
    var inputDidChange: ((String) -> Void)?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.font = .systemFont(ofSize: .XL)
        textField.delegate = self
        return textField
    }()
    
    private lazy var textFieldHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderWidth = CGFloat(.XS2)
        view.layer.borderColor = UIColor.systemGray2.cgColor
        return view
    }()
    
    private lazy var passcodeEye: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.width(equalTo: .XL)
        image.height(equalTo: .XL)
        image.contentMode = .scaleAspectFit
        image.isHidden = true
        image.image = UIImage(systemName: "eye.slash")
        image.tintColor = .blue
        return image
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = .S
        return stackView
    }()
    
    private lazy var validationLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: .M)
        label.textColor = .red 
        return label
    }()
    
    public init() {
        super.init(frame: .zero)
        setUp()
    }
    
    public convenience init(model: TextFieldModel, inputDidChange: @escaping ((String) -> Void)) {
        self.init()
        self.model = model
        self.inputDidChange = inputDidChange
        configure(model: model)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubviews()
        setUpUI()
        addConstraints()
    }
    
    private func  addSubviews() {
        textFieldHolder.addSubview(textField)
        textFieldHolder.addSubview(passcodeEye)
        stackView.addArrangedSubview(textFieldHolder)
        stackView.addArrangedSubview(validationLable)
        self.addSubview(stackView)
    }
    
    private func setUpUI() {
        backgroundColor = .clear

        textFieldHolder.layer.cornerRadius = .S
        textFieldHolder.clipsToBounds = true
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        self.inputDidChange?(textField.text ?? "")
    }
    
    private func addConstraints() {
        textField.top(toView: textFieldHolder, constant: .S)
        textField.bottom(toView: textFieldHolder, constant: .S)
        textField.left(toView: textFieldHolder, constant: .S)
        textField.right(toView: passcodeEye, constant: .XL3)
        
        passcodeEye.right(toView: textFieldHolder, constant: .M)
        passcodeEye.centerVertically(to: textFieldHolder)
        
        stackView.top(toView: self)
        stackView.bottom(toView: self)
        stackView.left(toView: self)
        stackView.right(toView: self)
    }
}

extension TextFieldView {
    
    public func configure(model: TextFieldModel?) {
        configurePasscodeEye(with: model)
        configureTextField(with: model)
        configureKeyboard(with: model)
        configureValidation(with: model)
        configureInputSecurity(with: model)
    }
    
    private func configurePasscodeEye(with model: TextFieldModel?) {
        guard let model = model, model.isSecureEntry else {
            passcodeEye.isHidden = true
            return
        }
        passcodeEye.isHidden = false
        addTapActionToImage()
    }
    
    private func configureInputSecurity(with model: TextFieldModel?) {
        guard let model = model, model.isSecureEntry else {
            textField.isSecureTextEntry = false
            return
        }
        textField.isSecureTextEntry = !isSecurityDisabled
    }
    
    private func configureKeyboard(with model: TextFieldModel?) {
        guard let model = model, let keyBoardType = model.keyboardType else {
            textField.keyboardType = .default
            return
        }
        textField.keyboardType = keyBoardType
    }
    
    private func configureBackground(for state: TextFieldState) {
        textFieldHolder.layer.borderColor = inputState == .inactive ? UIColor.systemGray2.cgColor : UIColor.blue.cgColor
    }
    
    private func configureValidation(with model: TextFieldModel?) {
        guard let model = model,
              let validationMessage = model.validationMessage else {
            validationLable.isHidden = true
            return
        }
        validationLable.isHidden = false
        validationLable.text = validationMessage
    }
    
    private func configureTextField(with model: TextFieldModel?) {
        guard let model = model else { return }
        if let placeholder = model.placeholder {
            textField.placeholder = placeholder
        }
    }
}

extension TextFieldView: UITextFieldDelegate {
    
    @objc public func textFieldDidEndEditing(_ textField: UITextField) {
        inputState = .inactive
    }
    
    @objc public func textFieldDidBeginEditing(_ textField: UITextField) {
        inputState = .inProgressOfEditing
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func addTapActionToImage() {
        passcodeEye.isUserInteractionEnabled = true
        passcodeEye.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPasscodeSecurityChange)))
    }
    
    @objc private func didTapPasscodeSecurityChange() {
        isSecurityDisabled.toggle()
        passcodeEye.image = isSecurityDisabled ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
    }
}

enum TextFieldState {
    case inactive
    case inProgressOfEditing
}

enum ButtonTapState {
    case tapped
    case notTapped
}
