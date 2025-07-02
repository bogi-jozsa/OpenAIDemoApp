//
//  GetInputItemsUseCase.swift
//  OpenAIDemoApp
//
//  Created by Boglárka Józsa on 29.06.2025.
//

import Foundation

struct GetInputItemsUseCase {
    
    @Injected(\.responsesRepository) private var repository: ResponsesRepository
    
    func execute(responseId: String) async throws -> InputItemModel {
        return try await repository.getInputItems(responseId: responseId)
    }
}
