//
//  Configuration.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 01.03.2023.
//

import Foundation

enum Configuration {
    
    enum Key: String {
        case apiUrl = "BPApiUrl" // replace BP (BaseProject) initials with your projects'
        case privacyPolicyUrl = "BPPrivacyPolicyUrl"
        case termsConditionsUrl = "BPTermsConditionsUrl"
        case appName = "CFBundleName"
        case appVersion = "CFBundleShortVersionString"
    }
    
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }
    
    // MARK: - Getters
    static func urlValue(for key: Key) -> String {
        let url: String? = try? value(for: key)
        return "https://\(url ?? "")"
    }
    
    static func stringValue(for key: Key) -> String {
        return Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String ?? ""
    }
    
    static func boolValue(for key: Key) -> Bool {
        let string = stringValue(for: key)
        return string == "YES" ? true : false
    }
    
    static func value<T>(for key: Key) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key.rawValue) else {
            throw Error.missingKey
        }
        
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }

}
