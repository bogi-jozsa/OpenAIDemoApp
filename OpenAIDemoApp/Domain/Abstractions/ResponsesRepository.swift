//
//  ResponsesRepository.swift
//  OpenAIDemoApp
//
//  Created by Boglárka Józsa on 19.06.2025.
//

import Foundation

protocol ResponsesRepository: AnyObject {
    func requestResponses(input: String, previousResponseId: String?) async throws -> ResponseModel
    func getInputItems(responseId: String) async throws -> InputItemModel
}
