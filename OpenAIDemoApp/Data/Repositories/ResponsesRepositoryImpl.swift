//
//  ResponsesRepositoryImpl.swift
//  OpenAIDemoApp
//
//  Created by Boglárka Józsa on 19.06.2025.
//

import Foundation

// MARK: - Repository Implementation

final class ResponsesRepositoryImpl: ResponsesRepository {
    @Injected(\.apiClient) private var apiClient: APIClient
    
    func requestResponses(responsesRequestModel: ResponsesRequestModel) async throws -> ResponseModel {
        
        // Map request
        var contents: [ChatContent] = []
        
        if let textContent = responsesRequestModel.text {
            contents.append(ChatContent(type: "input_text", text: textContent, image_url: nil))
        }
        
        if let imageContentUrl = responsesRequestModel.image_url {
            contents.append(ChatContent(type: "input_image", text: nil, image_url: imageContentUrl))
        }
        
        let responsesRequestDTO = ResponsesRequestDTO(input: [ChatInput(content: contents)], previousResponseId: responsesRequestModel.previousResponseId)
        
        return try await apiClient.performRequest(route: APIRouter.requestResponses(dto: responsesRequestDTO))
    }
    
    func getInputItems(responseId: String) async throws -> InputItemModel {
        try await apiClient.performRequest(route: APIRouter.getInputItems(responseId: responseId))
    }
    
    func deleteResponse(responseId: String) async throws -> DeleteMessageResponse {
        try await apiClient.performRequest(route: APIRouter.deleteResponse(responseId: responseId))
    }
    
}

// MARK: - Mock for previews

final class MockResponsesRepositoryImpl: ResponsesRepository {
    func requestResponses(responsesRequestModel: ResponsesRequestModel) async throws -> ResponseModel {
        return ResponseModel(id: "", object: nil, createdAt: nil, status: nil, error: nil, incompleteDetails: nil, instructions: nil, maxOutputTokens: nil, model: nil, output: [], parallelToolCalls: nil, previousResponseId: nil, reasoning: nil, store: nil, temperature: nil, text: nil, toolChoice: nil, tools: [], topP: nil, truncation: nil, usage: nil, user: nil, metadata: [:])
    }
    
    func getInputItems(responseId: String) async throws -> InputItemModel {
        return InputItemModel(object: "", data: [], firstId: "", lastId: "", hasMore: false)
    }
    
    func deleteResponse(responseId: String) async throws -> DeleteMessageResponse {
        return DeleteMessageResponse(id: "", object: "", deleted: false)
    }
}
