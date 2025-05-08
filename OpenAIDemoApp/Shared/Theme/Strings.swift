//
//  Strings.swift
//
//  Created by Vica Cotoarba on 21.09.2021.
//

import SwiftUI

// MARK: - Custom Localized Strings
/// Example of usage in code:
/// text = Strings.signIn.localized
enum Strings: String {

    // MARK: - Login
    
    case signIn = "sign-in"
    case emailAddress = "email-address-placeholder"
    case passcode = "password-placeholder"

}

// MARK: - Helpers

extension Strings {
    
    var localized: String {
        return self.rawValue.localized
    }
    
    func localized(with parameters: Any...) -> String {
        let parameters = parameters.map { String(describing: $0) }
        return self.rawValue.localized(parameters)
    }
}


// MARK: - Localization

protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    
    var localized: String { localized() }
    
    func localized(_ args: [CVarArg] = []) -> String {
        let languageCode = Locale.current.languageCode ?? Language.defaultValue.rawValue
        
        let path = Bundle.main.path(forResource: languageCode, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return String(format: localized(bundle: bundle), arguments: args)
    }
    
    /// Localizes a string using self as key.
    ///
    /// - Parameters:
    ///   - bundle: the bundle where the Localizable.strings file lies.
    /// - Returns: localized string.
    private func localized(bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}

enum Language: String {
    static let defaultValue = Language.english
    case english = "en"
}
