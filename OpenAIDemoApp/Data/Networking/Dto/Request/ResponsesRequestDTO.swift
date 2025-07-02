//
//  ResponsesRequestDTO.swift
//  OpenAIDemoApp
//
//  Created by Boglárka Józsa on 20.06.2025.
//

import Foundation

struct ResponsesRequestDTO: Encodable {
    let input: String
    let model = "gpt-4.1"
    let previousResponseId: String?
}
