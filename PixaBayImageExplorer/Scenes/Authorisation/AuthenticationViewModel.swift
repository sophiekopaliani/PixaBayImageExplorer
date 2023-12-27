//
//  AuthenticationViewModel.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import Foundation
import Resolver

protocol AuthenticationViewModel {
    var emailTextFieldModel: TextFieldModel{ get }
    var passTextFieldModel: TextFieldModel { get }
    func set(username: String)
    func set(password: String)
    func logIn() async throws
    func isButtonDissabled() -> Bool
}

class AuthenticationViewModelImpl: AuthenticationViewModel {
    
    @Injected var authorisationService: AuthorisationManagerUseCase
    @Injected var emailValidator: UserEmailValidatorUseCase
    @Injected var passwordValidator: PasswordLengthValidatorUseCase

    var isUserAbleToLogIn: Bool = false
    private var emailValidationErrorMessage: String? = nil
    private var passWordValidationErrorMessage: String? = nil
    
    private var credentials = Credentials()
    
    var emailTextFieldModel: TextFieldModel { .init(placeholder: "Email",
                                                    isSecureEntry: false,
                                                    keyboardType: .emailAddress,
                                                    inputText: nil,
                                                    isInputValid: true,
                                                    validationMessage: emailValidationErrorMessage)
    }
    
    var passTextFieldModel:TextFieldModel { .init(placeholder: "Password",
                                                  isSecureEntry: true,
                                                  keyboardType: .default,
                                                  inputText: nil,
                                                  isInputValid: true,
                                                  validationMessage: passWordValidationErrorMessage)}

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
    
    func isButtonDissabled() -> Bool {
        guard passWordValidationErrorMessage == nil && credentials.password != "",
              emailValidationErrorMessage == nil && credentials.email != "" else { return false }
        return true
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



