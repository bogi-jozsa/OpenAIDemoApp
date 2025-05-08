//
//  ItemMapper.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 03.03.2023.
//

import Foundation

struct ItemMapper: Mapper {
    typealias Input = ItemDto
    typealias Output = DemoItem

    func map(_ input: ItemDto) -> DemoItem? {
        return DemoItem(
            id: Int(input.id) ?? Int.random(in: 0...Int.max),
            content: input.content,
            priority: input.priority
        )
    }
    
    func reverseMap(_ output: DemoItem) -> ItemDto {
        return ItemDto(
            id: String(output.id),
            content: output.content,
            priority: output.priority
        )
    }
    
}
