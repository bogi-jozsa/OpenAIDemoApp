//
//  APIAuthenticator.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Bardi Orsolya on 27.08.2024.
//

import Alamofire
import Foundation

final class APIAuthenticator: Authenticator {

    @Injected(\.authenticationAPI) private var authenticationAPI: AuthenticationAPI

    func apply(_ credential: Tokens, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }

    func refresh(_ credential: Tokens, for session: Session, completion: @escaping (Result<Tokens, Error>) -> Void) {
        Task {
            do {
                let dto = RefreshTokenRequestDTO(refreshToken: credential.refreshToken)
                let responseDTO = try await authenticationAPI.refreshTokens(with: dto)
                let tokenMapper = TokenMapper()
                if let tokens = tokenMapper.map(responseDTO) {
                    Keychain.tokens = tokens
                    completion(.success(tokens))
                } else {
                    completion(.failure(APIError.authenticationFailed))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: Tokens) -> Bool {
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers.contains { $0.value == bearerToken }
    }
}

// MARK: - Tokens + AuthenticationCredential

extension Tokens: AuthenticationCredential {
    var requiresRefresh: Bool {
        let creationDate = Date(timeIntervalSince1970: TimeInterval(createdAt))
        return Date().timeIntervalSince(creationDate) > TimeInterval(expiresIn)
    }
}
