//
//  TextFieldModel.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import UIKit

public class TextFieldModel: Hashable {
    
    let placeholder: String?
    let isSecureEntry: Bool
    let keyboardType: UIKeyboardType?
    let inputText: String?
    let isInputValid: Bool
    let validationMessage: String?
    
    public init(placeholder: String? = nil,
                isSecureEntry: Bool = false,
                keyboardType: UIKeyboardType? = nil,
                inputText: String? = nil,
                isInputValid: Bool,
                validationMessage: String? = nil) {
        self.placeholder = placeholder
        self.isSecureEntry = isSecureEntry
        self.keyboardType = keyboardType
        self.inputText = inputText
        self.isInputValid = isInputValid
        self.validationMessage = validationMessage
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(placeholder)
        hasher.combine(inputText)
        hasher.combine(isInputValid)
    }
    
    public static func == (lhs: TextFieldModel, rhs: TextFieldModel) -> Bool {
        lhs.placeholder == rhs.placeholder &&
        lhs.isSecureEntry == rhs.isSecureEntry &&
        lhs.keyboardType == rhs.keyboardType &&
        lhs.inputText == rhs.inputText &&
        lhs.validationMessage == rhs.validationMessage
    }
}
