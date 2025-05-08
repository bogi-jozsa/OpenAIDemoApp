//
//  EmailTextFieldModel.swift
//
//  Created by Vica Cotoarba on 21.09.2021.
//

import Foundation

import UIKit

final class EmailTextFieldModel: TextFieldModel {
    
    var promptText = Strings.emailAddress.localized
    var contentType: UITextContentType? = .emailAddress
    var keyboardType = UIKeyboardType.emailAddress
    
    var text: String = "" {
        didSet {
            handleTextChanged()
        }
    }
    
    var errors: [CustomTextFieldErrorMessage] = [] {
        didSet {
            isValid = errors.allSatisfy({ $0.isValid })
        }
    }
    
    var isValid = true
    var isPassword = false
    var isClearText = true
    
    var onTextChanged: (_ text: String) -> Void
    
    private lazy var emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    private lazy var emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    
    init(onTextChanged: @escaping (_ text: String) -> Void) {
        self.onTextChanged = onTextChanged
    }
    
    func validate() {
        if emailPredicate.evaluate(with: text) {
            errors = []
        } else {
            errors = [
                CustomTextFieldErrorMessage(text: "")
            ]
        }
    }
}
