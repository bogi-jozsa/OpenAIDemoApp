//
//  GetItemsUseCaseTest.swift
//  WolfpackDigitalSwiftUIBaseProjectTests
//
//  Created by Dan Ilies on 13.11.2023.
//

import XCTest
@testable import WolfpackDigitalSwiftUIBaseProject

class GetItemsUseCaseTests: XCTestCase {
    
    override func setUp() {
        DependencyContainerKey.currentValue = MockDependencyContainer()
    }
    
    override func tearDown() {
        DependencyContainerKey.currentValue = nil
    }

    // MARK: - Test successful execution

    func testExecuteSuccess() async throws {
        // Given
        let useCase = GetItemsUseCase()

        // When
        let result = await useCase.execute()

        // Then
        switch result {
        case .success(let demoItems):
            XCTAssertFalse(demoItems.isEmpty, "Returned demo items should not be empty on success")
            XCTAssertEqual(demoItems.count, 3, "Returned item count does not match expectation from MockRepository")
        case .failure:
            XCTFail("Unexpected failure")
        }
    }

    // MARK: - Test failure scenario

    func testExecuteFailure() async throws {
        // Given
        // A custom repository mock that always throws an error
        DependencyContainerKey.currentValue?.itemsRepository = CustomMockItemsRepository()
        let useCase = GetItemsUseCase()

        // When
        let result = await useCase.execute()

        // Then
        switch result {
        case .success:
            XCTFail("Unexpected success")
        case .failure(let error):
            XCTAssertTrue(error is APIError, "Expected a specific error type")
        }
    }
    
}

// MARK: - Custom Repository

private final class CustomMockItemsRepository: ItemsRepository {
    func getDemoItems() async throws -> [WolfpackDigitalSwiftUIBaseProject.DemoItem] {
        throw APIError.notFound
    }
}
