//
//  DependencyContainer.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 21.02.2023.
//

import Alamofire
import Foundation

protocol DependencyContainer {
    // Use Cases
    var getItemsUseCase: GetItemsUseCase { get set }
    var requestResponsesUseCase: RequestResponsesUseCase { get set }
    var getInputItemsUseCase: GetInputItemsUseCase { get set }
    
    // Repositories
    var itemsRepository: ItemsRepository { get set }
    var responsesRepository: ResponsesRepository { get set }
    
    // APIs
    var apiClient: APIClient { get set }
    var authenticationAPI: AuthenticationAPI { get set }
    var itemsApi: ItemsApi { get set }
    
    // Helpers
    var authenticationInterceptor: AuthenticationInterceptor<APIAuthenticator> { get set }
}

struct DependencyContainerKey: InjectionKey {
    static var currentValue: DependencyContainer?
}
