//
//  TokenMapper.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Bardi Orsolya on 29.08.2024.
//

import Foundation

struct TokenMapper: Mapper {
    typealias Input = TokensResponseDTO
    typealias Output = Tokens

    func map(_ input: TokensResponseDTO) -> Tokens? {
        guard let accessToken = input.accessToken,
              let refreshToken = input.refreshToken,
              let expiresIn = input.expiresIn,
              let createdAt = input.createdAt else {
            return nil
        }
        return Tokens(accessToken: accessToken, 
                      refreshToken: refreshToken,
                      expiresIn: expiresIn,
                      createdAt: createdAt)
    }

    func reverseMap(_ output: Tokens) -> TokensResponseDTO {
        TokensResponseDTO(accessToken: output.accessToken,
                          refreshToken: output.refreshToken,
                          expiresIn: output.expiresIn,
                          createdAt: output.createdAt)
    }

}
