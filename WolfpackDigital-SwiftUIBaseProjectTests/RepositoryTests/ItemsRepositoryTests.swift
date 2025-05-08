//
//  ItemsRepositoryTests.swift
//  WolfpackDigitalSwiftUIBaseProjectTests
//
//  Created by Dan Ilies on 13.11.2023.
//

import XCTest
@testable import WolfpackDigitalSwiftUIBaseProject

class ItemsRepositoryTests: XCTestCase {
    
    override func setUp() {
        DependencyContainerKey.currentValue = MockDependencyContainer()
    }
    
    override func tearDown() {
        DependencyContainerKey.currentValue = nil
    }

    // MARK: - Items Count Test
    
    // With the default API Mock
    func testGetDemoItemsDefaultMock() async throws {
        // Given
        let repository: ItemsRepository = ItemsRepositoryImpl()

        // When
        let demoItems = try await repository.getDemoItems()

        // Then
        XCTAssert(demoItems.count == 3, "Returned demo items should match the ones in MockAPI")
    }
    
    // With a custom API Mock
    func testGetDemoItemsCustomMock() async throws {
        // Given
        DependencyContainerKey.currentValue?.itemsApi = CustomMockItemsAPI()
        let repository: ItemsRepository = ItemsRepositoryImpl()

        // When
        let demoItems = try await repository.getDemoItems()

        // Then
        XCTAssert(demoItems.count == 1, "Returned demo items should match the ones in CustomMockItemsAPI")
        XCTAssertEqual(demoItems.first?.id, Int("1"))
    }
    
    
}

// MARK: - Custom API Mock

private final class CustomMockItemsAPI: ItemsApi {
    func getAllItems() async throws -> [WolfpackDigitalSwiftUIBaseProject.ItemDto] {
        return [ItemDto(id: "1", content: "test", priority: "test")]
    }
}
