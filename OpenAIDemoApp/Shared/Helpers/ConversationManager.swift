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
    
    func updateCurrentConversationWithResponse(responseModel: ResponseModel, title: String? = nil) {
        guard let currentId = UserDefaults.currentConversationId,
              var history = UserDefaults.conversationHistory else {
            return
        }
        
        if let index = history.firstIndex(where: { $0.id == currentId }) {
            let updatedConversation = Conversation(
                id: history[index].id,
                title: title ?? history[index].title,
                latestResponseId: responseModel.id,
                latestResponse: responseModel
            )
            history[index] = updatedConversation
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

// MARK: - Helper Extensions

extension ConversationManager {
    
    /// Convert API response to ChatMessage array
    func convertToMessages(from inputItemModel: InputItemModel, latestResponse: ResponseModel? = nil) -> [ChatMessage] {
        var messages: [ChatMessage] = []
        
        // Convert API data to messages, sorted by creation order
        let sortedMessages = inputItemModel.data.reversed() // API returns newest first, we want oldest first
        
        for messageData in sortedMessages {
            guard let content = messageData.content.first?.text else { continue }
            
            let message = ChatMessage(
                id: messageData.id,
                role: messageData.role ?? "user",
                content: content
            )
            messages.append(message)
        }
        
        // Add the latest response if provided (since API doesn't include the most recent response)
        if let latestResponse = latestResponse,
           let responseText = latestResponse.output.first?.content.first?.text,
           !responseText.isEmpty {
            let responseMessage = ChatMessage(
                id: latestResponse.id,
                role: "assistant",
                content: responseText
            )
            messages.append(responseMessage)
        }
        
        return messages
    }
}
