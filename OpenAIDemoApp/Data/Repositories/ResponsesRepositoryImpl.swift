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
    
    func requestResponses(input: String, previousResponseId: String?) async throws -> ResponseModel {
        try await apiClient.performRequest(route: APIRouter.requestResponses(dto: ResponsesRequestDTO(input: input,
                                                                                                      previousResponseId: previousResponseId)))
    }
    
    func getInputItems(responseId: String) async throws -> InputItemModel {
        try await apiClient.performRequest(route: APIRouter.getInputItems(responseId: responseId))
    }
    
}

// MARK: - Mock for previews

final class MockResponsesRepositoryImpl: ResponsesRepository {
    func requestResponses(input: String, previousResponseId: String?) async throws -> ResponseModel {
        return ResponseModel(id: "", object: nil, createdAt: nil, status: nil, error: nil, incompleteDetails: nil, instructions: nil, maxOutputTokens: nil, model: nil, output: [], parallelToolCalls: nil, previousResponseId: nil, reasoning: nil, store: nil, temperature: nil, text: nil, toolChoice: nil, tools: [], topP: nil, truncation: nil, usage: nil, user: nil, metadata: [:])
    }
    
    func getInputItems(responseId: String) async throws -> InputItemModel {
        return InputItemModel(object: "", data: [], firstId: "", lastId: "", hasMore: false)
    }
}
