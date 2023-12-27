//
//  AuthenticationViewModel.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import Foundation
import Resolver

protocol AuthControllerDelegate: AnyObject {
    func reload()
}

protocol AuthenticationViewModel {
    func set(delegate: AuthControllerDelegate)
    var emailTextFieldModel: TextFieldModel{ get }
    var passTextFieldModel: TextFieldModel { get }
    func set(username: String)
    func set(password: String)
    func logIn() async throws
    var isButtonDissabled: Bool { get }
}

class AuthenticationViewModelImpl: AuthenticationViewModel {
    
    @Injected var authorisationService: AuthorisationManagerUseCase
    @Injected var emailValidator: UserEmailValidatorUseCase
    @Injected var passwordValidator: PasswordLengthValidatorUseCase
    
    private weak var delegate: AuthControllerDelegate?
    
    private var credentials = Credentials()

    private var emailValidationErrorMessage: String? = nil {
        didSet { delegate?.reload() }
    }
    private var passWordValidationErrorMessage: String? = nil {
        didSet { delegate?.reload() }
    }
    
    var emailTextFieldModel: TextFieldModel { .init(placeholder: "Email",
                                                    isSecureEntry: false,
                                                    keyboardType: .emailAddress,
                                                    validationMessage: emailValidationErrorMessage)
    }
    
    var passTextFieldModel: TextFieldModel { .init(placeholder: "Password",
                                                  isSecureEntry: true,
                                                  keyboardType: .default,
                                                  validationMessage: passWordValidationErrorMessage)}
    
    var isButtonDissabled: Bool {
        guard passWordValidationErrorMessage == nil && credentials.password != "",
              emailValidationErrorMessage == nil && credentials.email != "" else { return false }
        return true
    }
    
    func set(delegate: AuthControllerDelegate) {
        self.delegate = delegate
    }

    func set(username: String) {
        credentials.email = username
        try? vallidateEmailInput()
    }
    
    func set(password: String) {
        credentials.password = password
        try? vallidatePasswordInput()
    }
    
    func vallidateEmailInput() throws  {
        do {
            try emailValidator.validate(email: credentials.email)
            emailValidationErrorMessage = nil
        } catch ValidatorError.invalidEmail {
            emailValidationErrorMessage = ValidatorError.invalidEmail.customDescription
            throw ValidatorError.invalidEmail
        }
    }
    
    func vallidatePasswordInput() throws {
        do {
            try passwordValidator.validate(password: credentials.password)
            passWordValidationErrorMessage = nil
        } catch ValidatorError.invalidPassword {
            passWordValidationErrorMessage = ValidatorError.invalidPassword.customDescription
            throw ValidatorError.invalidPassword
        }
    }
    
    func logIn() async throws {
        do {
            try await authorisationService.loginUser(email: credentials.email,
                                                     password: credentials.password)
        } catch ValidatorError.emailDoesNotExist {
            emailValidationErrorMessage = ValidatorError.emailDoesNotExist.customDescription
            throw ValidatorError.wrongParameters
        } catch ValidatorError.passwordDoesNotMatch {
            passWordValidationErrorMessage = ValidatorError.passwordDoesNotMatch.customDescription
            throw ValidatorError.wrongParameters
        }
    }
}



