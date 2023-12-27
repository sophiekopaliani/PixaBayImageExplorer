//
//  RegistrationViewModel.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import Foundation
import Resolver

protocol RegistrationControllerDelegate: AnyObject {
    func reload()
}

protocol RegistrationViewModel {
    func set(delegate: RegistrationControllerDelegate)
    var emailTextFieldModel: TextFieldModel{ get }
    var passTextFieldModel: TextFieldModel { get }
    var userAccaptableAgeRange: Range<Int> { get }
    var isButtonDissabled: Bool { get }
    func set(email: String)
    func set(password: String)
    func set(age: Int)
    func registerUser() async throws
}

class RegistrationViewModelImpl: RegistrationViewModel {

    @Injected var authorisationService: AuthorisationManagerUseCase
    @Injected var emailValidator: UserEmailValidatorUseCase
    @Injected var passwordValidator: PasswordLengthValidatorUseCase
    @Injected var userAgeValidator: UserAgeValidatorUseCase
    
    private var emailValidationErrorMessage: String? = nil {
        didSet  { delegate?.reload() }
    }
    private var passWordValidationErrorMessage: String? = nil {
        didSet  { delegate?.reload() }
    }
    private var ageValidationErrorMessage: String? = nil {
        didSet  { delegate?.reload() }
    }
    
    private weak var delegate: RegistrationControllerDelegate?
    
    private var credentials = RegistrationCredentials()
    
    var userAccaptableAgeRange: Range<Int> {
        userAgeValidator.validAgeRange
    }
    
    var emailTextFieldModel: TextFieldModel  {.init(placeholder: "Email",
                                                         isSecureEntry: false,
                                                         keyboardType: .emailAddress,
                                                         inputText: nil,
                                                         validationMessage: emailValidationErrorMessage)}
    
    var passTextFieldModel: TextFieldModel  {.init(placeholder: "Password",
                                                        isSecureEntry: false,
                                                        keyboardType: .default,
                                                        inputText: nil,
                                                        validationMessage: passWordValidationErrorMessage)}
    
    var isButtonDissabled: Bool {
        guard passWordValidationErrorMessage == nil && credentials.password != "",
              emailValidationErrorMessage == nil && credentials.email != "",
              ageValidationErrorMessage == nil && credentials.age != nil else { return false }
        return true
    }
    
    func set(delegate: RegistrationControllerDelegate) {
        self.delegate = delegate
    }
    
    func set(email: String) {
        credentials.email = email
        try? vallidateEmailInput()
    }
    
    func set(password: String) {
        credentials.password = password
        try? vallidatePasswordInput()
    }
    
    func set(age: Int) {
        credentials.age = age
        try? validateAgeInput()
    }
    
    func vallidateEmailInput() throws  {
        do {
            try emailValidator.validate(email: credentials.email)
            emailValidationErrorMessage = nil
        } catch ValidatorError.invalidEmail {
            emailValidationErrorMessage = ValidatorError.invalidEmail.customDescription
            throw ValidatorError.wrongParameters
        }
    }
    
    func vallidatePasswordInput() throws {
        do {
            try passwordValidator.validate(password: credentials.password)
            passWordValidationErrorMessage = nil
        } catch ValidatorError.invalidPassword {
            passWordValidationErrorMessage = ValidatorError.invalidPassword.customDescription
            throw ValidatorError.wrongParameters
        }
    }
    
    func validateAgeInput() throws {
        do {
            try userAgeValidator.validate(age: credentials.age)
            ageValidationErrorMessage = nil
        } catch ValidatorError.invalidAge {
            ageValidationErrorMessage = ValidatorError.invalidAge.customDescription
            throw ValidatorError.wrongParameters
        }
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
