//
//  MapperProtocol.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 03.03.2023.
//

import Foundation

protocol Mapper {
    associatedtype Input
    associatedtype Output
    func map(_ input: Input) -> Output?
    func reverseMap(_ output: Output) -> Input
}
