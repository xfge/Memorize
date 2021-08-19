//
//  MemoryGame.swift
//  Memorize
//
//  Created by 葛笑非 on 2021/8/19.
//

import Foundation

struct MemoryGame<CardContent> {
    private(set) var cards: [Card]
    
    init(numberOfPairsOfCards: Int, createCard: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCard(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    func choose(_ card: Card) {
        
    }
    
    struct Card {
        var content: CardContent
        var isFaceUp = false
        var isMatched = false
    }
}
