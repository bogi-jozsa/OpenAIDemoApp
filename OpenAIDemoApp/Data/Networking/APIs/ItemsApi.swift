//
//  ItemsApi.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 02.03.2023.
//

import Foundation
import Alamofire

// MARK: - Protocol

protocol ItemsApi {
    func getAllItems() async throws -> [ItemDto]
}


// MARK: - Implementation

class ItemsApiImpl: ItemsApi {

    @Injected(\.apiClient) private var apiClient: APIClient

    func getAllItems() async throws -> [ItemDto] {
        try await apiClient.performRequest(route: APIRouter.getAllItems)
    }
}

// MARK: - Mock

class MockItemsApiImpl: ItemsApi {
    func getAllItems() async throws -> [ItemDto] {
        return [
            ItemDto(id: "1", content: "mock item", priority: "first"),
            ItemDto(id: "2", content: "second mock item", priority: "second"),
            ItemDto(id: "3", content: "third mock item", priority: "third")
        ]
    }
}
