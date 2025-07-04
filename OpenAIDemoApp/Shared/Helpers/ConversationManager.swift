//
//  ConversationManager.swift
//  OpenAIDemoApp
//

import Foundation

class ConversationManager {
    static let shared = ConversationManager()
    
    private init() {}
    
    // MARK: - Conversation Management
    
    func createNewConversation(title: String? = nil) -> Conversation {
        let conversationTitle = title ?? "New Chat \(Date().formatted(date: .abbreviated, time: .shortened))"
        let newConversation = Conversation(title: conversationTitle)
        
        // Save as current conversation
        UserDefaults.currentConversationId = newConversation.id
        
        // Add to history
        var history = UserDefaults.conversationHistory ?? []
        history.append(newConversation)
        UserDefaults.conversationHistory = history
        
        return newConversation
    }
    
    func getCurrentConversation() -> Conversation? {
        guard let currentId = UserDefaults.currentConversationId,
              let history = UserDefaults.conversationHistory else {
            return nil
        }
        
        return history.first { $0.id == currentId }
    }
    
    func getAllConversations() -> [Conversation] {
        return UserDefaults.conversationHistory?.sorted { $0.createdAt > $1.createdAt } ?? []
    }
    
    func addMessageToCurrentConversation(_ message: ChatMessage) {
        guard let currentId = UserDefaults.currentConversationId,
              var history = UserDefaults.conversationHistory else {
            return
        }
        
        if let index = history.firstIndex(where: { $0.id == currentId }) {
            history[index].messages.append(message)
            UserDefaults.conversationHistory = history
        }
    }
    
    func switchToConversation(id: String) -> Conversation? {
        guard let history = UserDefaults.conversationHistory,
              let conversation = history.first(where: { $0.id == id }) else {
            return nil
        }
        
        UserDefaults.currentConversationId = id
        return conversation
    }
    
    func deleteConversation(id: String) {
        var history = UserDefaults.conversationHistory ?? []
        history.removeAll { $0.id == id }
        UserDefaults.conversationHistory = history
        
        // If we deleted the current conversation, clear current ID
        if UserDefaults.currentConversationId == id {
            UserDefaults.currentConversationId = nil
        }
    }
    
    func clearAllConversations() {
        UserDefaults.conversationHistory = nil
        UserDefaults.currentConversationId = nil
    }
}
