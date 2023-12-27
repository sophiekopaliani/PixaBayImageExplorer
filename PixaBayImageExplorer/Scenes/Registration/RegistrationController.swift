//
//  RegistrationController.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import UIKit
import Resolver

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
            self.vm.set(username: mail)
            emailTextField.model = self.vm.emailTextFieldModel
            self.configureButton(isEnabled: vm.isButtonDissabled())
        }
        return tf
    }()
    
    private lazy var passwordTextField: TextFieldView = {
        var tf = TextFieldView(model: vm.passTextFieldModel) { [weak self] password in
            guard let self = self else { return }
            self.vm.set(password: password)
            passwordTextField.model = self.vm.passTextFieldModel
            self.configureButton(isEnabled: vm.isButtonDissabled())
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
        containerStack.addArrangedSubview(spacer)
        containerStack.addArrangedSubview(registerButton)

    }

    private func setUpUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Registration"
        
        navigationController?.navigationBar.tintColor = .blue;
        self.configureButton(isEnabled: vm.isButtonDissabled())
    }

    private func addConstraints() {
        containerStack.top(toView: self.view)
        containerStack.bottom(toView: self.view)
        containerStack.left(toView: self.view)
        containerStack.right(toView: self.view)
    }

    private func configure(with model: AuthenticationViewModel) {

    }

    private func didTapRegisterButton(_ action: UIAction) {
        Task.detached { @MainActor [weak self] in
            guard let self else { return }
            do {
                try await self.vm.registerUser()
                self.navigateToMainPage()
            } catch ValidatorError.wrongParameters {
                emailTextField.model =  self.vm.emailTextFieldModel
                passwordTextField.model = self.vm.passTextFieldModel
            } catch {
                self.showErrorMessage()
            }
        }
    }
    
    private func configureButton(isEnabled: Bool) {
        registerButton.isEnabled = isEnabled
    }
    
    private func showErrorMessage() {
        print("show Error Message")
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
        configureButton(isEnabled: vm.isButtonDissabled())
    }
}
