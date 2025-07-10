//
//  HomeViewModel.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 20.02.2023.
//

import Foundation

struct ChatMessage: Hashable, Codable, Identifiable {
    let id: String
    let role: String // "user" or "assistant"
    let content: String
    let timestamp: Date
    
    init(id: String, role: String, content: String) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = Date()
    }
    
    var requestString: String? {
        return role == "user" ? content : nil
    }
    
    var responseString: String? {
        return role == "assistant" ? content : nil
    }
}

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
    @Published var isLoadingHistory = false
    
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
        Task {
            await loadConversationHistory(conversation)
        }
    }
    
    @MainActor
    private func loadConversationHistory(_ conversation: Conversation) async {
        isLoadingHistory = true
        
        // Switch to conversation
        if let switchedConversation = conversationManager.switchToConversation(id: conversation.id) {
            currentConversation = switchedConversation
            
            // Load history if conversation has a response ID
            if let responseId = switchedConversation.latestResponseId {
                do {
                    let inputItems = try await getInputItemsUseCase.execute(responseId: responseId)
                    // Pass the stored latest response to include it in the conversation
                    let messages = conversationManager.convertToMessages(
                        from: inputItems,
                        latestResponse: switchedConversation.latestResponse
                    )
                    chatMessages = messages
                } catch {
                    errorMessage = "Failed to load conversation history: \(error.localizedDescription)"
                    chatMessages = []
                }
            } else {
                chatMessages = []
            }
        }
        
        isLoadingHistory = false
    }
    
    func loadConversations() {
        conversations = conversationManager.getAllConversations()
    }
    
    private func loadCurrentConversation() {
        if let current = conversationManager.getCurrentConversation() {
            Task {
                await loadConversationHistory(current)
            }
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
        
        // Add user message immediately for better UX
        let userMessage = ChatMessage(id: UUID().uuidString, role: "user", content: currentPrompt)
        chatMessages.append(userMessage)
        
        do {
            // Get the latest response ID from current conversation for context
            let previousResponseId: String? = currentConversation?.latestResponseId
            
            let responseModel = try await requestResponsesUseCase.execute(responsesRequestModel: ResponsesRequestModel(text: currentPrompt,
                                                                                                                       image_url: nil,
                                                                                                                       previousResponseId: previousResponseId))
            
            // "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Gfp-wisconsin-madison-the-nature-boardwalk.jpg/2560px-Gfp-wisconsin-madison-the-nature-boardwalk.jpg"
            
            await MainActor.run {
                self.isLoading = false
                
                // Extract response text
                let responseText = responseModel.output.first?.content.first?.text ?? ""
                
                // Add AI response message
                let aiMessage = ChatMessage(id: responseModel.id, role: "assistant", content: responseText)
                self.chatMessages.append(aiMessage)
                
                // Update conversation with latest response ID and full response
                self.conversationManager.updateCurrentConversationWithResponse(
                    responseModel: responseModel,
                    title: self.chatMessages.count <= 2 ? String(currentPrompt.prefix(30)) : nil
                )
                
                // Update current conversation reference
                self.currentConversation = self.conversationManager.getCurrentConversation()
                self.loadConversations()
            }
        } catch let error {
            await MainActor.run {
                self.isLoading = false
                self.prompt = currentPrompt // Restore prompt on error
                // Remove the user message that was added optimistically
                if let lastMessage = self.chatMessages.last, lastMessage.role == "user" {
                    self.chatMessages.removeLast()
                }
                self.errorMessage = "Error creating request: \(error.localizedDescription)"
            }
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
    
    func refreshCurrentConversation() {
        guard let current = currentConversation else { return }
        Task {
            await loadConversationHistory(current)
        }
    }
}
