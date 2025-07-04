//
//  UserDefaultsExtensions.swift
//  OpenAIDemoApp
//
//  Created by Boglárka Józsa on 30.06.2025.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let conversationHistory = "conversationHistory"
        static let currentConversationId = "currentConversationId"
    }
    
    @ObjectUserDefault(key: Keys.conversationHistory)
    static var conversationHistory: [Conversation]?
    
    @ObjectUserDefault(key: Keys.currentConversationId)
    static var currentConversationId: String?
}

// MARK: - Conversation Models

struct Conversation: Codable, Identifiable {
    let id: String
    let title: String
    let createdAt: Date
    var messages: [ChatMessage]
    
    init(id: String = UUID().uuidString, title: String, messages: [ChatMessage] = []) {
        self.id = id
        self.title = title
        self.createdAt = Date()
        self.messages = messages
    }
}

struct ChatMessage: Hashable, Codable, Identifiable {
    let id: String
    let requestString: String?
    let responseString: String?
    let timestamp: Date
    
    init(id: String, requestString: String?, responseString: String?) {
        self.id = id
        self.requestString = requestString
        self.responseString = responseString
        self.timestamp = Date()
    }
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
