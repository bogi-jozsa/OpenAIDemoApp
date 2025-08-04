//
//  APIRouter.swift
//
//  Created by Vica Cotoarba on 17.09.2021.
//

import Foundation
import Alamofire

/// Implements APIConfiguration
/// and defines all the routes (or a part of the routes)
enum APIRouter: APIConfiguration {
    
    // MARK: - Accounts
    
    case login(email: String, password: String)
    case refreshAuth(dto: RefreshTokenRequestDTO)
    case getAllItems
    case requestResponses(dto: ResponsesRequestDTO)
    case getInputItems(responseId: String)
    case deleteResponse(responseId: String)
    
    // MARK: - APIConfiguration
    
    var baseUrl: String {
        return Configuration.urlValue(for: .apiUrl)
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllItems, .getInputItems:
            return .get
        case .login, .requestResponses, .deleteResponse:
            return .post
        case .refreshAuth:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getAllItems: return "items"
        case .login: return "login"
        case .refreshAuth: return "refreshToken"
        case .requestResponses: return "responses"
        case .getInputItems(let responseId): return "responses/\(responseId)/input_items"
        case .deleteResponse(let responseId): return "responses/\(responseId)"
        }
    }

    var needsAuthorization: Bool {
        switch self {
        case .login, .refreshAuth, .requestResponses, .getInputItems, .deleteResponse:
            false
        case .getAllItems:
            true
        }
    }

    var headers: [String: String] {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["Authorization"] = "Bearer \(Configuration.openAIApiKey())"

        return headers
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            LoginRequest(email: email, password: password).params
        case .refreshAuth(let dto):
            dto.params
        case .requestResponses(let dto):
            dto.params
        case .getAllItems, .getInputItems, .deleteResponse:
            nil
        }
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        .reloadIgnoringLocalCacheData
    }
    
}

struct LoginRequest: Encodable {
    let email: String
    let password: String
}
