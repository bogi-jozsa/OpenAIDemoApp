//
//  ResponsesRequestDTO.swift
//  OpenAIDemoApp
//
//  Created by Boglárka Józsa on 20.06.2025.
//

import Foundation

struct ResponsesRequestModel: Codable {
    var model: String = "gpt-4.1"
    let text: String?
    let image_url: String?
    let previousResponseId: String?
}

struct ResponsesRequestDTO: Codable {
    var model: String = "gpt-4.1"
    let input: [ChatInput]
    let previousResponseId: String?
}

struct ChatInput: Codable {
    var role: String = "user"
    let content: [ChatContent]
}

struct ChatContent: Codable {
    let type: String
    let text: String?
    let image_url: String?
}
