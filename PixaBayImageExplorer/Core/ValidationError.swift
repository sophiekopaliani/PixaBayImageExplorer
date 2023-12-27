//
//  ValidationError.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import Foundation

enum ValidatorError: Error {
    case invalidEmail
    case invalidPassword
    case invalidAge
    case emailDoesNotExist
    case passwordDoesNotMatch
    case wrongParameters
    case cannotLogin
    case cannotRegister
    
    var customDescription: String {
        switch self {
        case .invalidEmail: return "Please enter correct email"
        case .invalidPassword: return "Please ensure you password size is between 6 and 12"
        case .invalidAge: return "Please ensure you are an adult and alive"
        case .emailDoesNotExist: return "Your email wasn't found"
        case .passwordDoesNotMatch: return "Your passwrond isn't right"
        case .wrongParameters: return "Entered parameters aren't right"
        case .cannotLogin: return "Can not log in"
        case .cannotRegister: return "Can not register"
        }
    }
}
