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
    
    // MARK: - APIConfiguration
    
    var baseUrl: String {
        return Configuration.urlValue(for: .apiUrl)
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllItems:
            return .get
        case .login:
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
        }
    }

    var needsAuthorization: Bool {
        switch self {
        case .login, .refreshAuth:
            false
        case .getAllItems:
            true
        }
    }

    var headers: [String: String] {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"

        return headers
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            LoginRequest(email: email, password: password).params
        // ex: case .register(let request): return request.params
        case .refreshAuth(let dto):
            dto.params
        case .getAllItems:
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
