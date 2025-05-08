//
//  APIClient.swift
//
//  Created by Vica Cotoarba on 17.09.2021.
//

import Foundation
import Alamofire

// MARK: - API Client

/// Protocol that's used by concrete APIs to perform requests
/// This can also be adopted by concrete classes which will then handle custom API requests
protocol APIClient: AnyObject {
    func performRequest<T: Decodable>(route: APIConfiguration) async throws -> T
}

final class APIClientImpl: APIClient {

    @Injected(\.authenticationInterceptor) private var authenticationInterceptor: AuthenticationInterceptor<APIAuthenticator>

    func performRequest<T: Decodable>(route: APIConfiguration) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            let interceptor = authenticationInterceptorIfNeeded(forRoute: route)
            AF.request(route, interceptor: interceptor)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

    private func authenticationInterceptorIfNeeded(forRoute route: APIConfiguration) -> RequestInterceptor? {
        guard route.needsAuthorization else { return nil }

        authenticationInterceptor.credential = Keychain.tokens
        return authenticationInterceptor
    }

}
