//
//  Keychain.swift
//
//  Created by Vica Cotoarba on 17.09.2021.
//

import Foundation
import Security

enum Keychain {
    private enum Keys {
        static let tokens = "baseproject.tokens.key"
        static let email = "baseproject.email.key"
        static let auth = "baseproject.auth.key"
    }

    @ObjectKeychains(key: Keys.tokens)
    static var tokens: Tokens?

    @ObjectKeychains(key: Keys.email)
    static var email: String?

    @ObjectKeychains(key: Keys.auth)
    static var auth: String?
}

// MARK: - Property wrappers

@propertyWrapper
public struct ObjectKeychains<Value: Codable> {
    let key: String
    private let container = KeychainWrapper.standard

    public var wrappedValue: Value? {
        get {
            guard let data = container.object(forKey: key) else { return nil }
            return try? JSONDecoder().decode(Value.self, from: data)
        }
        set {
            guard let newValue = newValue else {
                container.delete(key: key)
                return
            }
            guard let encodedData = try? JSONEncoder().encode(newValue) else { return }
            container.set(encodedData, forKey: key)
        }
    }

    public init(key: String) {
        self.key = key
    }
}

@propertyWrapper
struct Keychains {
    let key: String
    private let container = KeychainWrapper.standard

    var wrappedValue: String? {
        get {
            container.value(forKey: key)
        }
        set {
            guard let newValue = newValue else {
                container.delete(key: key)
                return
            }
            container.set(newValue, forKey: key)
        }
    }
}

// MARK: - Keychain wrapper

private final class KeychainWrapper {

    static let standard = KeychainWrapper()

    @discardableResult
    func set(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else {
            return false
        }
        return self.set(data, forKey: key)
    }

    func value(forKey key: String) -> String? {
        guard let data = self.object(forKey: key) else {
            return nil
        }
        guard let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        return string
    }

    @discardableResult
    func set(_ data: Data, forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)

        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)

        return status == noErr
    }

    func object(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
            let existingItem = item as? Data else {
                return nil
        }

        return existingItem
    }

    @discardableResult
    func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status: OSStatus = SecItemDelete(query as CFDictionary)

        return status == noErr
    }

    @discardableResult
    func clear() -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword
        ]

        let status: OSStatus = SecItemDelete(query as CFDictionary)

        return status == noErr
    }
}
