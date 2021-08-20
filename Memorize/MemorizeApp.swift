//
//  MemorizeApp.swift
//  Memorize
//
//  Created by 葛笑非 on 2021/8/18.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
