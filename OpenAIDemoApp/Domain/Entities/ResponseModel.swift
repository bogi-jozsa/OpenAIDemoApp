//
//  ResponseModel.swift
//  OpenAIDemoApp
//
//  Created by Boglárka Józsa on 19.06.2025.
//

import Foundation

struct ResponseModel: Codable {
    init(id: String, object: String?, createdAt: Int?, status: String?, error: ResponseError?, incompleteDetails: IncompleteDetails?, instructions: String?, maxOutputTokens: Int?, model: String?, output: [OutputItem], parallelToolCalls: Bool?, previousResponseId: String?, reasoning: Reasoning?, store: Bool?, temperature: Double?, text: TextObject?, toolChoice: String?, tools: [Tool], topP: Double?, truncation: String?, usage: Usage?, user: String?, metadata: [String : String]) {
        self.id = id
        self.object = object
        self.createdAt = createdAt
        self.status = status
        self.error = error
        self.incompleteDetails = incompleteDetails
        self.instructions = instructions
        self.maxOutputTokens = maxOutputTokens
        self.model = model
        self.output = output
        self.parallelToolCalls = parallelToolCalls
        self.previousResponseId = previousResponseId
        self.reasoning = reasoning
        self.store = store
        self.temperature = temperature
        self.text = text
        self.toolChoice = toolChoice
        self.tools = tools
        self.topP = topP
        self.truncation = truncation
        self.usage = usage
        self.user = user
        self.metadata = metadata
    }
    
    let id: String
    let object: String?
    let createdAt: Int?
    let status: String?
    let error: ResponseError?
    let incompleteDetails: IncompleteDetails?
    let instructions: String?
    let maxOutputTokens: Int?
    let model: String?
    let output: [OutputItem]
    let parallelToolCalls: Bool?
    let previousResponseId: String?
    let reasoning: Reasoning?
    let store: Bool?
    let temperature: Double?
    let text: TextObject?
    let toolChoice: String?
    let tools: [Tool]
    let topP: Double?
    let truncation: String?
    let usage: Usage?
    let user: String?
    let metadata: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case id, object, status, error, instructions, model, output, tools, store, temperature, text, usage, user, metadata
        case createdAt = "created_at"
        case incompleteDetails = "incomplete_details"
        case maxOutputTokens = "max_output_tokens"
        case parallelToolCalls = "parallel_tool_calls"
        case previousResponseId = "previous_response_id"
        case reasoning
        case toolChoice = "tool_choice"
        case topP = "top_p"
        case truncation
    }
}

struct ResponseError: Codable {
    let code: String?
    let message: String
    let param: String?
    let type: String
}

struct IncompleteDetails: Codable {
    let reason: String?
}

struct OutputItem: Codable {
    let type: String?
    let id: String?
    let status: String?
    let role: String?
    let content: [ContentItem]
}

struct ContentItem: Codable {
    let type: String?
    let text: String?
    let annotations: [String]
}

struct Reasoning: Codable {
    let effort: String?
    let summary: String?
}

struct TextObject: Codable {
    let format: TextFormat?
}

struct TextFormat: Codable {
    let type: String?
}

struct Tool: Codable {
    // The structure is empty in your example; define if needed later
}

struct Usage: Codable {
    let inputTokens: Int?
    let inputTokensDetails: InputTokensDetails?
    let outputTokens: Int?
    let outputTokensDetails: OutputTokensDetails?
    let totalTokens: Int?

    enum CodingKeys: String, CodingKey {
        case inputTokens = "input_tokens"
        case inputTokensDetails = "input_tokens_details"
        case outputTokens = "output_tokens"
        case outputTokensDetails = "output_tokens_details"
        case totalTokens = "total_tokens"
    }
}

struct InputTokensDetails: Codable {
    let cachedTokens: Int?

    enum CodingKeys: String, CodingKey {
        case cachedTokens = "cached_tokens"
    }
}

struct OutputTokensDetails: Codable {
    let reasoningTokens: Int?

    enum CodingKeys: String, CodingKey {
        case reasoningTokens = "reasoning_tokens"
    }
}
