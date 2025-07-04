//
//  HomeViewModel.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 20.02.2023.
//

import Foundation

protocol HomeDelegate: AnyObject {
    func logout()
}

final class HomeViewModel: ObservableObject {
    
    // MARK: - Properties and Init
    
    private weak var delegate: HomeDelegate?
    private let conversationManager = ConversationManager.shared
    
    @Published var errorMessage: String?
    @Published var prompt = ""
    @Published var isLoading = false
    @Published var chatMessages: [ChatMessage] = []
    @Published var conversations: [Conversation] = []
    @Published var currentConversation: Conversation?
    
    @Injected(\.requestResponsesUseCase) private var requestResponsesUseCase: RequestResponsesUseCase
    @Injected(\.getInputItemsUseCase) private var getInputItemsUseCase: GetInputItemsUseCase
    
    init(delegate: HomeDelegate? = nil) {
        self.delegate = delegate
        loadConversations()
        loadCurrentConversation()
    }
    
    // MARK: - Conversation Management
    
    func createNewConversation() {
        let newConversation = conversationManager.createNewConversation()
        currentConversation = newConversation
        chatMessages = []
        loadConversations()
    }
    
    func switchToConversation(_ conversation: Conversation) {
        if let switchedConversation = conversationManager.switchToConversation(id: conversation.id) {
            currentConversation = switchedConversation
            chatMessages = switchedConversation.messages
        }
    }
    
    func loadConversations() {
        conversations = conversationManager.getAllConversations()
    }
    
    private func loadCurrentConversation() {
        if let current = conversationManager.getCurrentConversation() {
            currentConversation = current
            chatMessages = current.messages
        } else {
            // Create first conversation if none exists
            createNewConversation()
        }
    }
    
    // MARK: - Actions
    
    @MainActor
    func sendRequest() async {
        guard !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isLoading = true
        let currentPrompt = prompt
        prompt = ""
        
        do {
            // Get the last response ID from current conversation for context
            let previousResponseId: String? = chatMessages.last?.id
            let responseModel = try await requestResponsesUseCase.execute(input: currentPrompt, previousResponseId: previousResponseId)
            
            await MainActor.run {
                self.isLoading = false
                
                // Create new message
                let newMessage = ChatMessage(
                    id: responseModel.id,
                    requestString: currentPrompt,
                    responseString: responseModel.output.first?.content.first?.text ?? ""
                )
                
                // Add to current conversation
                self.chatMessages.append(newMessage)
                self.conversationManager.addMessageToCurrentConversation(newMessage)
                
                // Update current conversation reference
                self.currentConversation = self.conversationManager.getCurrentConversation()
                
                // Update conversation title if it's the first message
                if self.chatMessages.count == 1 {
                    self.updateConversationTitle(with: currentPrompt)
                }
            }
        } catch let error {
            await MainActor.run {
                self.isLoading = false
                self.prompt = currentPrompt // Restore prompt on error
                self.errorMessage = "Error creating request: \(error.localizedDescription)"
            }
        }
    }
    
    private func updateConversationTitle(with firstMessage: String) {
        guard let currentId = currentConversation?.id,
              var history = UserDefaults.conversationHistory else { return }
        
        if let index = history.firstIndex(where: { $0.id == currentId }) {
            // Use first 30 characters of the first message as title
            let title = String(firstMessage.prefix(30))
            history[index] = Conversation(
                id: history[index].id,
                title: title,
                messages: history[index].messages
            )
            UserDefaults.conversationHistory = history
            currentConversation = history[index]
            loadConversations()
        }
    }
    
    func deleteConversation(_ conversation: Conversation) {
        conversationManager.deleteConversation(id: conversation.id)
        loadConversations()
        
        // If we deleted the current conversation, create a new one
        if currentConversation?.id == conversation.id {
            createNewConversation()
        }
    }
    
    func clearAllHistory() {
        conversationManager.clearAllConversations()
        createNewConversation()
        loadConversations()
    }
}
