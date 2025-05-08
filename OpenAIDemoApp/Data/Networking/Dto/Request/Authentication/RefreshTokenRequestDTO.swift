//
//  RefreshTokenRequestDTO.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Bardi Orsolya on 29.08.2024.
//

import Foundation

struct RefreshTokenRequestDTO: Encodable {
    let refreshToken: String
    let grantType = "refresh_token"
}
