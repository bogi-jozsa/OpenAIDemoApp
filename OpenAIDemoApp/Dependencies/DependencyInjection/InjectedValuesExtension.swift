//
//  InjectedValuesExtension.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 21.02.2023.
//

import Alamofire
import Foundation

// MARK: - Container

extension InjectedValues {
    private var dependencyContainer: DependencyContainer {
        get {
            guard let injected = Self[DependencyContainerKey.self] else {
                if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil {
                    let mockContainer = MockDependencyContainer()
                    Self[DependencyContainerKey.self] = mockContainer
                    return mockContainer
                } else {
                    fatalError()
                }
            }
            return injected
        }
        set {
            Self[DependencyContainerKey.self] = newValue
        }
    }
}

// MARK: - Use Cases

extension InjectedValues {
    
    var getItemsUseCase: GetItemsUseCase {
        get { return dependencyContainer.getItemsUseCase }
        set { dependencyContainer.getItemsUseCase = newValue }
    }
    
    var requestResponsesUseCase: RequestResponsesUseCase {
        get { return dependencyContainer.requestResponsesUseCase }
        set { dependencyContainer.requestResponsesUseCase = newValue }
    }
    
    var getInputItemsUseCase: GetInputItemsUseCase {
        get { return dependencyContainer.getInputItemsUseCase }
        set { dependencyContainer.getInputItemsUseCase = newValue }
    }
}

// MARK: - Repositories

extension InjectedValues {
    
    var itemsRepository: ItemsRepository {
        get { return dependencyContainer.itemsRepository }
        set { dependencyContainer.itemsRepository = newValue }
    }
    
    var responsesRepository: ResponsesRepository {
        get { return dependencyContainer.responsesRepository }
        set { dependencyContainer.responsesRepository = newValue }
    }
}

// MARK: - APIs

extension InjectedValues {

    var apiClient: APIClient {
        get { dependencyContainer.apiClient }
        set { dependencyContainer.apiClient = newValue }
    }

    var authenticationAPI: AuthenticationAPI {
        get { dependencyContainer.authenticationAPI }
        set { dependencyContainer.authenticationAPI = newValue }
    }

    var itemsApi: ItemsApi {
        get { return dependencyContainer.itemsApi }
        set { dependencyContainer.itemsApi = newValue }
    }
}

// MARK: - Helpers

extension InjectedValues {

    var authenticationInterceptor: AuthenticationInterceptor<APIAuthenticator> {
        get { dependencyContainer.authenticationInterceptor }
        set { dependencyContainer.authenticationInterceptor = newValue }
    }
}
