//
//  EmojiTheme.swift
//  Memorize
//
//  Created by 葛笑非 on 2021/8/19.
//

import Foundation

struct EmojiTheme: Identifiable, Hashable, Codable {
    var name: String
    var numberOfPairs: Int
    var rgbaColor: RGBAColor
    var emojis: String
    var removedEmojis: String = ""
    
    var id = UUID()
    
    init(name: String = "", emojis: String = "", rgbaColor: RGBAColor) {
        self.name = name
        self.emojis = emojis
        self.rgbaColor = rgbaColor
        self.numberOfPairs = min(emojis.count, 20)
    }
}
