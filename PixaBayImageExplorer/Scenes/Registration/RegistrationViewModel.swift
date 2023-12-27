//
//  RegistrationViewModel.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import Foundation
import Resolver

protocol RegistrationViewModel { 
    var emailTextFieldModel: TextFieldModel{ get }
    var passTextFieldModel: TextFieldModel { get }
    var userAccaptableAgeRange: Range<Int> { get }
    func set(username: String)
    func set(password: String)
    func set(age: Int)
    func registerUser() async throws
    func isButtonDissabled() -> Bool
}

class RegistrationViewModelImpl: RegistrationViewModel {

    @Injected var authorisationService: AuthorisationManagerUseCase
    @Injected var emailValidator: UserEmailValidatorUseCase
    @Injected var passwordValidator: PasswordLengthValidatorUseCase
    @Injected var userAgeValidator: UserAgeValidatorUseCase
    
    private var emailValidationErrorMessage: String? = nil
    private var passWordValidationErrorMessage: String? = nil
    private var ageValidationErrorMessage: String? = nil
    
    
    var userAccaptableAgeRange: Range<Int> {
        userAgeValidator.validAgeRange
    }
    
    var emailTextFieldModel: TextFieldModel  {.init(placeholder: "Email",
                                                         isSecureEntry: false,
                                                         keyboardType: .emailAddress,
                                                         inputText: nil,
                                                         isInputValid: true, //TODO: remove
                                                         validationMessage: emailValidationErrorMessage)}
    
    var passTextFieldModel: TextFieldModel  {.init(placeholder: "Password",
                                                        isSecureEntry: false,
                                                        keyboardType: .default,
                                                        inputText: nil,
                                                        isInputValid: true, //TODO: remove
                                                        validationMessage: passWordValidationErrorMessage) }
    
    private var credentials = RegistrationCredentials()

    var isAgeInputValid: Bool {
        return userAgeValidator.isValid(age: credentials.age)
    }
    
    func set(username: String) {
        credentials.email = username
        try? vallidateEmailInput()
    }
    
    func set(password: String) {
        credentials.password = password
        try? vallidatePasswordInput()
    }
    
    func set(age: Int) {
        credentials.age = age
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
              emailValidationErrorMessage == nil && credentials.email != "",
              ageValidationErrorMessage == nil && credentials.age != nil else { return false }
        return true
    }
    
    func registerUser() async throws {
        do {
            try await authorisationService.registerUser(
                email: credentials.email,
                password: credentials.password,
                age: credentials.age)
        } catch  ValidatorError.emailDoesNotExist {
            emailValidationErrorMessage = ValidatorError.emailDoesNotExist.customDescription
            throw ValidatorError.wrongParameters
        } catch ValidatorError.passwordDoesNotMatch {
            passWordValidationErrorMessage = ValidatorError.passwordDoesNotMatch.customDescription
            throw ValidatorError.wrongParameters
        } catch {
            throw error
        }
    }
}
