//
//  UserEmailValidatorUseCase.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import Foundation

protocol UserEmailValidatorUseCase {
    func validate(email: String) throws
}

public class UserEmailValidatorImpl: UserEmailValidatorUseCase {
    func validate(email: String) throws {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: email) else { throw ValidatorError.invalidEmail }
    }
}
