//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 葛笑非 on 2021/8/19.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {

    static func createMemoryGame(theme: EmojiTheme) -> MemoryGame<String> {
        let randomEmojis = theme.emojis.shuffled()
        // Extra credit 2: If the default count of pairs is nil, the theme will use a random number.
        return MemoryGame(numberOfPairsOfCards: theme.numberOfPairs ?? Int.random(in: 2..<theme.emojis.count)) { pairIndex in
            // Required task 5: No dead emoji
            // Hint 15/16: closures catch local variables
            randomEmojis[pairIndex]
        }
    }
    
    @Published private var model: MemoryGame<String>
    
    private var theme: EmojiTheme
    
    init() {
        theme = EmojiTheme.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    var points: Int {
        model.points
    }
    
    var themeName: String {
        theme.name
    }
    
    // Hint 4/5: Let the theme model be UI-independent and the view model be the interpreter.
    var color: Color {
        switch theme.color {
        case "blue":
            return .blue
        case "yellow":
            return .yellow
        case "purple":
            return .purple
        case "red":
            return .red
        case "orange":
            return .orange
        case "pink":
            return .pink
        default:
            return .gray
        }
    }
    
    // MARK: - Intents
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func restart() {
        // Required task 11: Restart with a random theme
        // Hint 14: Allow duplicate code with int()
        theme = EmojiTheme.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
}
