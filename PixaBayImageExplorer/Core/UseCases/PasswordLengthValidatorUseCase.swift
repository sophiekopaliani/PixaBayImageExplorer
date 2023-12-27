//
//  PasswordLengthValidatorUseCase.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import Foundation


protocol PasswordLengthValidatorUseCase {
    func validate(password: String) throws
}

public class PasswordLengthValidatorImpl: PasswordLengthValidatorUseCase {
    private let passwordLengthRange = 6..<12

    func validate(password: String) throws {
        guard passwordLengthRange.contains(password.count) else { throw ValidatorError.invalidPassword }
    }
}
