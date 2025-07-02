//
//  HomeViewModel.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 20.02.2023.
//

import Foundation

struct ChatMessage: Hashable, Codable {
    let id: String
    let requestString: String?
    let responseString: String?
}

protocol HomeDelegate: AnyObject {
    func logout()
}

final class HomeViewModel: ObservableObject {
    
    // MARK: - Properties and Init
    
    private weak var delegate: HomeDelegate?
    
    @Published var errorMessage: String?
    
    @Published var prompt = ""
    @Published var isLoading = false
    @Published var isFirstRequest = true
    
    @Published var chatMessages: [ChatMessage] = []
    
    @Injected(\.requestResponsesUseCase) private var requestResponsesUseCase: RequestResponsesUseCase
    @Injected(\.getInputItemsUseCase) private var getInputItemsUseCase: GetInputItemsUseCase
    
    init(delegate: HomeDelegate? = nil) {
        self.delegate = delegate
    }
    
    // MARK: - Actions
    
    @MainActor
    func sendRequest() async {
        isLoading = true
        
        do {
            let previousResponseId: String? = chatMessages.last?.id
            let responseModels = try await self.requestResponsesUseCase.execute(input: prompt, previousResponseId: previousResponseId)
            
            await MainActor.run {
                self.isLoading = false
                self.chatMessages.append(ChatMessage(id: responseModels.id, requestString: prompt, responseString: responseModels.output.first?.content.first?.text ?? ""))
                self.prompt = ""
                
                if let lastResponseId = chatMessages.last?.id {
                    UserDefaults.lastResponseId = lastResponseId
                    print(lastResponseId)
                }
                if let lastRequestString = chatMessages.last?.requestString {
                    UserDefaults.lastFirstRequestText = lastRequestString
                    isFirstRequest = false
                }
            }
        } catch let error {
            await MainActor.run {
                self.isLoading = false
                errorMessage = "Error creating request: \(error.localizedDescription)"
            }
        }
    }
    
    func chatHistoryPressed() {
        Task {
            await getChatHistory()
        }
    }
    
    @MainActor
    func getChatHistory() async {
        self.chatMessages = []
        isLoading = true
        
        do {
            let responseId: String = UserDefaults.lastResponseId ?? ""
            let inputItemsList = try await self.getInputItemsUseCase.execute(responseId: responseId)
            
            await MainActor.run {
                self.isLoading = false
                
                // to change
                for i in stride(from: 0, to: inputItemsList.data.count, by: 2) {
                    let first = inputItemsList.data[i]
                    let second = i + 1 < inputItemsList.data.count ? inputItemsList.data[i + 1] : nil
                    
                    self.chatMessages.append(ChatMessage(id: first.id,
                                                         requestString: first.content.first?.text,
                                                         responseString: second?.content.first?.text))
                }
            }
        } catch let error {
            await MainActor.run {
                self.isLoading = false
                errorMessage = "Error creating request: \(error.localizedDescription)"
                print("Error creating request: \(error.localizedDescription)")
            }
        }
    }
}
