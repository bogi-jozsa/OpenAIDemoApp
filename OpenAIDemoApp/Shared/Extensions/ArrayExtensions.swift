//
//  ArrayExtensions.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Vica Cotoarba on 30.06.2022.
//

import Foundation

extension Array {
    /**
        Safely retreive the element at specified specified index. Returns the element if the index exists and nil otherwise.
        - Parameter index: The index you want to access
    */
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
