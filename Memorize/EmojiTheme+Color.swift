//
//  EmojiTheme+Color.swift
//  Memorize
//
//  Created by 葛笑非 on 2022/2/21.
//

import SwiftUI

extension EmojiTheme {
    init(name: String = "", emojis: String = "", color: Color) {
        self.init(name: name, emojis: emojis, rgbaColor: RGBAColor(color: color))
    }
    
    var color: Color {
        get { Color(rgbaColor: rgbaColor) }
        set { rgbaColor = RGBAColor(color: newValue) }
    }
}
