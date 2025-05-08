//
//  AppDependencyContainer.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 21.02.2023.
//

import Alamofire
import Foundation

class AppDependencyContainer: DependencyContainer {
    // UseCases
    lazy var getItemsUseCase: GetItemsUseCase = GetItemsUseCase()

    // Repositories
    lazy var itemsRepository: ItemsRepository = ItemsRepositoryImpl()

    // APIs
    lazy var apiClient: APIClient = APIClientImpl()
    lazy var itemsApi: ItemsApi = ItemsApiImpl()
    lazy var authenticationAPI: AuthenticationAPI = AuthenticationAPIImpl()

    // Helpers
    lazy var authenticationInterceptor: AuthenticationInterceptor<APIAuthenticator> = AuthenticationInterceptor(authenticator: APIAuthenticator())

    init() {
        DependencyContainerKey.currentValue = self
    }
    
}
