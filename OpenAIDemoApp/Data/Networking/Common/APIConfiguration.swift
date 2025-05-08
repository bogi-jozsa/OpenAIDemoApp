//
//  APIConfiguration.swift
//
//  Created by Vica Cotoarba on 17.09.2021.
//

import Foundation
import Alamofire

/**
 * Generic API Configuration protocol
 * - to be implemented by enums that define APIs
 */
protocol APIConfiguration: URLRequestConvertible {
    var baseUrl: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: [String: String] { get }
    var parameters: Parameters? { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var needsAuthorization: Bool { get }
//    var multipartData: MultipartData? { get }
//    var authService: AuthenticationServiceProtocol { get }
    
    func asURLRequest() throws -> URLRequest
}

extension APIConfiguration {
    
    func asURLRequest() throws -> URLRequest {
        let url = try (baseUrl + path).asURL()
        var urlRequest = URLRequest(url: url) // .appendingPathComponent(path))

        // Method
        urlRequest.httpMethod = method.rawValue

        // Headers
        var headers: [String: String] = urlRequest.allHTTPHeaderFields ?? [:]
        headers.merge(self.headers, uniquingKeysWith: { (_, last) in last })
        urlRequest.allHTTPHeaderFields = headers

        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        // Cache Policy
        urlRequest.cachePolicy = cachePolicy

        return urlRequest
    }
}
