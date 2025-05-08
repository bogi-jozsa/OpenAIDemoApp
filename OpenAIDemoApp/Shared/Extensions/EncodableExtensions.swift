//
//  EncodableExtensions.swift
//
//  Created by Vica Cotoarba on 20.09.2021.
//

import Foundation


extension Encodable {
    
    subscript(key: String) -> Any? {
        return params[key]
    }
    
    var params: [String: Any] {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        jsonEncoder.dateEncodingStrategy = .formatted(DateFormatter.iso)
        return (try? JSONSerialization.jsonObject(with: jsonEncoder.encode(self))) as? [String: Any] ?? [:]
    }
}
