//
//  DeleteResponseUseCase.swift
//  OpenAIDemoApp
//
//  Created by Boglárka Józsa on 10.07.2025.
//

import Foundation

struct DeleteResponseUseCase {
    
    @Injected(\.responsesRepository) private var repository: ResponsesRepository
    
    func execute(responseId: String) async throws -> DeleteMessageResponse {
        return try await repository.deleteResponse(responseId: responseId)
    }
}

struct DeleteMessageResponse: Codable {
    let id: String?
    let object: String?
    let deleted: Bool?
}
