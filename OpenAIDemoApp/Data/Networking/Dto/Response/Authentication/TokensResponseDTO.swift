//
//  TokensResponseDTO.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Bardi Orsolya on 29.08.2024.
//

import Foundation

struct TokensResponseDTO: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let expiresIn: Int?
    let createdAt: Int?
}
