//
//  HomeRepository.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 20.02.2023.
//

import Foundation

// MARK: - Repository Implementation

final class ItemsRepositoryImpl: ItemsRepository {
    
    @Injected(\.itemsApi) private var itemsApi: ItemsApi
    private let itemMapper = ItemMapper() // Could also be injected, but it's quite tied to the repository
    
    func getDemoItems() async throws -> [DemoItem] {        
        try await itemsApi.getAllItems().compactMap { dto in
            itemMapper.map(dto)
        }
    }
    
}

// MARK: - Mock for previews

final class MockItemsRepositoryImpl: ItemsRepository {
    
    func getDemoItems() async throws -> [DemoItem] {
        return [
            DemoItem(id: 1, content: "abc", priority: "first"),
            DemoItem(id: 2, content: "def", priority: "second"),
            DemoItem(id: 5, content: "mno", priority: "fifth")
        ]
    }
    
}
