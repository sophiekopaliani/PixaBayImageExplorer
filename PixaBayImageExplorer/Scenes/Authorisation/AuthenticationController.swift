//
//  AuthenticationController.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import UIKit
import NotificationBannerSwift

class AuthenticationController: UIViewController {
    
    var vm: AuthenticationViewModel
    
    var bottomConstraint: NSLayoutConstraint?
    
    private lazy var containerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = .M
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(top: .XL3, leading: .XL, bottom: .XL, trailing: .XL)
        return stackView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        var v = UIActivityIndicatorView()
        v.hidesWhenStopped = true
        return  v
    }()
    
    private lazy var emailTextField: TextFieldView = {
        var tf = TextFieldView(model: vm.emailTextFieldModel) { [weak self] mail in
            guard let self = self else { return }
            self.vm.set(username: mail)
        }
        return tf
    }()

    private lazy var passwordTextField: TextFieldView = {
        var tf = TextFieldView(model: vm.passTextFieldModel) { [weak self] password in
            guard let self = self else { return }
            self.vm.set(password: password)
        }
        return tf
    }()
    
    private lazy var loginLikeButton: UIButton = {
        var b = UIButton()
        b.tintColor = .blue
        b.configuration = .filled()
        b.setTitle("Log In", for: .normal)
        b.layer.cornerRadius = .S
        b.addAction(.init(handler: didTapLoginButton), for: .touchUpInside)
        return b
    }()
    
    private lazy var registerButton: UIButton = {
        var b = UIButton()
        b.configuration = .borderedTinted()
        b.setTitle("Register", for: .normal)
        b.layer.cornerRadius = .S
        b.addAction(.init(handler: didTapRegisterButton), for: .touchUpInside)
        return b
    }()
    
    init(vm: AuthenticationViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
        vm.set(delegate: self)
        addKeyboardNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeKeyboardObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        setUp()
    }
    
    private func setUp() {
        addSubviews()
        setUpUI()
        addConstraints()
        configureButton(isEnabled: vm.isButtonDissabled)
    }
    
    private func  addSubviews() {
        view.addSubview(containerStack)
        containerStack.addArrangedSubview(activityIndicator)
        containerStack.addArrangedSubview(activityIndicator)
        containerStack.addArrangedSubview(emailTextField)
        containerStack.addArrangedSubview(passwordTextField)
        containerStack.addArrangedSubview(loginLikeButton)
        containerStack.addArrangedSubview(registerButton)
    }
    
    private func setUpUI() {
        containerStack.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Log In"
        navigationController?.navigationBar.tintColor = .blue;
    }
    
    private func addConstraints() {
        containerStack.left(toView: self.view)
        containerStack.right(toView: self.view)
        bottomConstraint = containerStack.bottom(toView: view)
    }
    
    private func didTapLoginButton(_ action: UIAction) {
        activityIndicator.startAnimating()
        
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                activityIndicator.startAnimating()
                try await self.vm.logIn()
                activityIndicator.stopAnimating()
                self.navigateToMainPage()
            } catch ValidatorError.wrongParameters {
                activityIndicator.stopAnimating()
            } catch {
                activityIndicator.stopAnimating()
                self.showErrorMessage(error: error)
            }
        }
    }
    
    private func configureButton(isEnabled: Bool) {
        loginLikeButton.isEnabled = isEnabled
    }
    
    private func didTapRegisterButton(_ action: UIAction) {
        navigateToRegistrationPage()
    }
    
    private func showErrorMessage(error: Error) {
        let banner = FloatingNotificationBanner(title: error.localizedDescription,
                                                style: .danger)
        banner.show(edgeInsets: .init(top: .L, left: .M, bottom: .zero, right: .M),
                    cornerRadius: .S)
    }
}

extension AuthenticationController: AuthControllerDelegate {
    func reload() {
        emailTextField.model =  self.vm.emailTextFieldModel
        passwordTextField.model = self.vm.passTextFieldModel
        configureButton(isEnabled: vm.isButtonDissabled)
    }
}

//MARK: Keyboard functionality
extension AuthenticationController {
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject> {
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyboardRect = frame?.cgRectValue
            if let keyboardHeight = keyboardRect?.height {
                bottomConstraint?.constant = -keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        bottomConstraint?.constant = 0
    }
}
