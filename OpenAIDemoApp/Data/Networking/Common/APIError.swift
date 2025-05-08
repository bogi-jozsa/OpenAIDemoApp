//
//  APIError.swift
//
//  Created by Vica Cotoarba on 17.09.2021.
//

import Foundation

enum APIError: Error {
    case sessionFailed(error: URLError)
    case decodingFailed
    case other(Error)
    case missingToken
    case tokenExpired
    case refreshTokenExpired
    case notFound
    case badRequest
    case invalidStatusCode(value: Int, data: Data)
    case authenticationFailed
}

enum MockAPIError: Error {
    case genericMockError
}
