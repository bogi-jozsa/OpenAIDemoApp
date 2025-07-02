//
//  UserDefaultsExtensions.swift
//  OpenAIDemoApp
//
//  Created by Boglárka Józsa on 30.06.2025.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let lastResponseId = "lastResponseId"
        static let lastFirstRequestText = "lastFirstRequestText"
    }
    
    @ObjectUserDefault(key: Keys.lastResponseId)
    static var lastResponseId: String?
    
    @ObjectUserDefault(key: Keys.lastFirstRequestText)
    static var lastFirstRequestText: String?
    
}

@propertyWrapper
struct ObjectUserDefault<Value: Codable> {
    let key: String
    private let container: UserDefaults = .standard

    var wrappedValue: Value? {
        get {
            guard let savedData = container.object(forKey: key) as? Data else { return nil }
            let decodedValue = try? JSONDecoder().decode(Value.self, from: savedData)
            return decodedValue
        }
        set {
            let encodedValue = try? JSONEncoder().encode(newValue)
            container.set(encodedValue, forKey: key)
        }
    }
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    private let container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}
