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
    func isValid(age: Int?) -> Bool
}

public class UserAgeValidatorImpl: UserAgeValidatorUseCase {
     let validAgeRange = 18..<99
    var validationError: String = "Please ensure you are an adult and alive"

     func isValid(age: Int?) -> Bool {
         guard let age = age else { return false }
         return validAgeRange.contains(age)
     }
}
