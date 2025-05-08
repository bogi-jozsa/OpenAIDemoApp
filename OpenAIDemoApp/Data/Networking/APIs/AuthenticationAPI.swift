//
//  AuthenticationAPI.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Bardi Orsolya on 27.08.2024.
//

protocol AuthenticationAPI {
    func refreshTokens(with dto: RefreshTokenRequestDTO) async throws -> TokensResponseDTO
}

final class AuthenticationAPIImpl: AuthenticationAPI {

    @Injected(\.apiClient) private var apiClient: APIClient

    func refreshTokens(with dto: RefreshTokenRequestDTO) async throws -> TokensResponseDTO {
        let route = APIRouter.refreshAuth(dto: dto)
        return try await apiClient.performRequest(route: route)
    }
}

// MARK: - Mock

struct MockAuthenticationAPI: AuthenticationAPI {

    func refreshTokens(with dto: RefreshTokenRequestDTO) async throws -> TokensResponseDTO {
        TokensResponseDTO(accessToken: nil, refreshToken: nil, expiresIn: nil, createdAt: nil)
    }
}
