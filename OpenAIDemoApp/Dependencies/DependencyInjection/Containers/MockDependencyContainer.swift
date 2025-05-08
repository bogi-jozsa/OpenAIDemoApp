//
//  MockDependencyContainer.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 21.02.2023.
//

import Alamofire
import Foundation

class MockDependencyContainer: DependencyContainer {
    // APIs
    lazy var apiClient: APIClient = APIClientImpl()
    lazy var itemsApi: ItemsApi = MockItemsApiImpl()
    lazy var authenticationAPI: AuthenticationAPI = MockAuthenticationAPI()

    // UseCases
    lazy var getItemsUseCase: GetItemsUseCase = GetItemsUseCase()

    // Repositories
    lazy var itemsRepository: ItemsRepository = MockItemsRepositoryImpl()

    // Helpers
    lazy var authenticationInterceptor: AuthenticationInterceptor<APIAuthenticator> = AuthenticationInterceptor(authenticator: APIAuthenticator())

    init() {
        DependencyContainerKey.currentValue = self
    }
    
}
