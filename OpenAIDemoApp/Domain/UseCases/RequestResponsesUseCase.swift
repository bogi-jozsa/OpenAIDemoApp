//
//  RequestResponsesUseCase.swift
//  OpenAIDemoApp
//
//  Created by Boglárka Józsa on 19.06.2025.
//

import Foundation

struct RequestResponsesUseCase {
    
    @Injected(\.responsesRepository) private var repository: ResponsesRepository
    
    func execute(input: String, previousResponseId: String?) async throws -> ResponseModel {
        return try await repository.requestResponses(input: input, previousResponseId: previousResponseId)
    }
}
