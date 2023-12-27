//
//  RegistrationController.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import UIKit
import Resolver
import NotificationBannerSwift

class RegistrationController: UIViewController {
    
    @Injected var vm: RegistrationViewModel

    private lazy var containerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = .M
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(top: .XL,
                                                   leading: .XL,
                                                   bottom: .XL,
                                                   trailing: .XL)
        return stackView
    }()
    
    private lazy var emailTextField: TextFieldView = {
        var tf = TextFieldView(model: vm.emailTextFieldModel) { [weak self] mail in
            guard let self = self else { return }
            self.vm.set(email: mail)
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

    private lazy var agePicker: UIPickerView = {
        var p = UIPickerView()
        p.dataSource = self
        p.layer.borderWidth = CGFloat(.XS2)
        p.layer.cornerRadius = .S
        p.layer.borderColor = UIColor.systemGray2.cgColor
        return p
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        var v = UIActivityIndicatorView()
        v.hidesWhenStopped = true
        return  v
    }()

    private lazy var spacer: UIView = {
        var v = UIView()
        return v
    }()

    private lazy var registerButton: UIButton = {
        var b = UIButton()
        b.tintColor = .blue
        b.configuration = .filled()
        b.setTitle("Register", for: .normal)
        b.layer.cornerRadius = .S
        b.addAction(.init(handler: didTapRegisterButton), for: .touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        vm.set(delegate: self)
        self.view.backgroundColor = .systemBackground
        agePicker.delegate = self
        agePicker.dataSource = self
        setUp()
    }

    private func setUp() {
        addSubviews()
        setUpUI()
        addConstraints()
    }

    private func  addSubviews() {
        view.addSubview(containerStack)
        containerStack.addArrangedSubview(emailTextField)
        containerStack.addArrangedSubview(passwordTextField)
        containerStack.addArrangedSubview(agePicker)
        containerStack.addArrangedSubview(activityIndicator)
        containerStack.addArrangedSubview(spacer)
        containerStack.addArrangedSubview(registerButton)

    }

    private func setUpUI() {
        navigationItem.title = "Registration"
        self.configureButton(isEnabled: vm.isButtonDissabled)
    }

    private func addConstraints() {
        containerStack.top(toView: self.view)
        containerStack.bottom(toView: self.view)
        containerStack.left(toView: self.view)
        containerStack.right(toView: self.view)
    }

    private func didTapRegisterButton(_ action: UIAction) {
        activityIndicator.startAnimating()
        Task { [weak self] in
            do {
                try await self?.vm.registerUser()
                self?.activityIndicator.stopAnimating()
                self?.navigateToMainPage()
            } catch ValidatorError.wrongParameters {
                self?.activityIndicator.stopAnimating()
            } catch {
                self?.showErrorMessage(error: error)
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func configureButton(isEnabled: Bool) {
        registerButton.isEnabled = isEnabled
    }
    
    private func showErrorMessage(error: Error) {
            let banner = FloatingNotificationBanner(title: error.localizedDescription,
                                                    style: .danger)
            banner.show(edgeInsets: .init(top: .L, left: .M, bottom: .zero, right: .M),
                        cornerRadius: .S)
    }
}

extension RegistrationController: RegistrationControllerDelegate {
    func reload() {
        self.emailTextField.model =  self.vm.emailTextFieldModel
        self.passwordTextField.model = self.vm.passTextFieldModel
        self.configureButton(isEnabled: self.vm.isButtonDissabled)
    }
}


extension RegistrationController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        vm.userAccaptableAgeRange.count
    }
}

extension RegistrationController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(vm.userAccaptableAgeRange.lowerBound + row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        vm.set(age: vm.userAccaptableAgeRange.lowerBound + row)
    }
}
