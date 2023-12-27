//
//  UserAgeValidatorUseCase.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import Foundation

protocol UserAgeValidatorUseCase {
    var validationError: String { get }
    var validAgeRange: Range<Int> { get }
    func validate(age: Int?) throws
}

public class UserAgeValidatorImpl: UserAgeValidatorUseCase {
     let validAgeRange = 18..<99
    var validationError: String = "Please ensure you are an adult and alive"

    func validate(age: Int?) throws {
        guard let age = age,
              validAgeRange.contains(age) else { throw ValidatorError.invalidAge }
    }

}
