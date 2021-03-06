//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by čįŽé on 2021/8/19.
//

import Foundation

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis = ["ð", "ð", "ð", "ð", "ð", "ð", "ð", "ð", "ð", "ðŦ", "ð", "ð", "ð", "ðĨ­", "ð", "ðĨĨ", "ðĨ", "ð", "ð", "ðĨ", "ðĨĶ"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame(numberOfPairsOfCards: Int.random(in: 4...emojis.count)) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: [Card] {
        model.cards
    }
    
    // MARK: - Intents
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
