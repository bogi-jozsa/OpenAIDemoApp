//
//  HomeRepositoryProtocol.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 20.02.2023.
//

import Foundation

protocol ItemsRepository: AnyObject {
    func getDemoItems() async throws -> [DemoItem]
}
