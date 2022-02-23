//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 葛笑非 on 2021/8/19.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card

    static func createMemoryGame(theme: EmojiTheme) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
        let randomEmojis = emojis.shuffled()
        return MemoryGame(numberOfPairsOfCards: theme.numberOfPairs) {
            String(randomEmojis[randomEmojis.index(randomEmojis.startIndex, offsetBy: $0)])
        }
    }
    
    @Published private var model: MemoryGame<String>
    
    private var theme: EmojiTheme {
        didSet { restart() }
    }
    
    init(theme: EmojiTheme) {
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    var cards: [Card] {
        model.cards
    }
    
    var points: Int {
        model.points
    }
    
    var ongoing: Bool {
        model.ongoing
    }
    
    var isSuccessMatch: Bool {
        model.isSuccessMatch
    }
    
    var isGameCompleted: Bool {
        model.cards.filter { !$0.isMatched }.isEmpty
    }
    
    // MARK: - Theme properties
    
    var themeName: String {
        theme.name
    }
    
    var themeColor: Color {
        theme.color
    }
    
    // MARK: - Intents
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    func start() {
        model.start()
    }
    
    func completeGame() {
        model.displayAllCards()
    }
}
