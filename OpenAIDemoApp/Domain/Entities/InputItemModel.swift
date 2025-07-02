//
//  InputItemModel.swift
//  OpenAIDemoApp
//
//  Created by Boglárka Józsa on 24.06.2025.
//

import Foundation

struct InputItemModel: Codable {
    let object: String?
    let data: [MessageData]
    let firstId: String?
    let lastId: String?
    let hasMore: Bool?
    
    init(object: String, data: [MessageData], firstId: String, lastId: String, hasMore: Bool) {
        self.object = object
        self.data = data
        self.firstId = firstId
        self.lastId = lastId
        self.hasMore = hasMore
    }
}

struct MessageData: Codable, Identifiable {
    let id: String
    let type: String?
    let status: String?
    let role: String?
    let content: [MessageContent]
}

struct MessageContent: Codable {
    let type: String?
    let text: String?
}

