//
//  MemorizeApp.swift
//  Memorize
//
//  Created by čįŽé on 2021/8/18.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private var game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
