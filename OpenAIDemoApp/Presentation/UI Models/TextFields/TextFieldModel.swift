//
//  TextFieldModel.swift
//
//  Created by Vica Cotoarba on 21.09.2021.
//

import UIKit
import SwiftUI

protocol TextFieldModel: AnyObject {
    var promptText: String { get set }
    var contentType: UITextContentType? { get set }
    var keyboardType: UIKeyboardType { get set }
    var text: String { get set }
    var errors: [CustomTextFieldErrorMessage] { get set }
    var isValid: Bool { get set }
    var isPassword: Bool { get set }
    var isClearText: Bool { get set }
    var onTextChanged: (_ text: String) -> Void { get set }
    
    func validate()
    func clearOldValidation()
    func handleTextChanged()
}

extension TextFieldModel {
    func clearOldValidation() {
        self.errors = []
    }
    
    func handleTextChanged() {
        clearOldValidation()
        onTextChanged(text)
    }
}

struct CustomTextFieldErrorMessage: Identifiable {
    var id: String { return text }
    
    let image: ImageResource?
    let text: String
    var isValid: Bool = false
    
    var color: Color {
        return overriddenColor ?? (isValid ? .appBlack39 : .appRed3D)
    }
    
    var overriddenColor: Color?
    
    init(text: Strings) {
        self.init(text: text.localized)
    }
    
    init(text: String) {
        self.image = nil
        self.text = text
    }
    
    init(image: ImageResource, text: Strings, isValid: Bool = false) {
        self.init(image: image, text: text.localized, isValid: isValid)
    }
    
    init(image: ImageResource, text: String, isValid: Bool = false) {
        self.image = image
        self.text = text
        self.isValid = isValid
    }
}
