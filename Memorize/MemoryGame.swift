//
//  MemoryGame.swift
//  Memorize
//
//  Created by 葛笑非 on 2021/8/19.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    init(numberOfPairsOfCards: Int, createCard: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCard(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
    }
    
    mutating func choose(_ card: Card) {
        if let cardIndex = cards.firstIndex(where: { $0.id == card.id }), !card.isMatched, !card.isFaceUp {
            if let indexOfPotentialMatchCard = indexOfTheOneAndOnlyFaceUpCard {
                if (cards[indexOfPotentialMatchCard].content == card.content) {
                    cards[indexOfPotentialMatchCard].isMatched = true
                    cards[cardIndex].isMatched = true
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                for cardIndex in cards.indices {
                    cards[cardIndex].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = cardIndex
            }
            cards[cardIndex].isFaceUp = true
        }
    }
    
    struct Card: Identifiable {
        var content: CardContent
        var isFaceUp = false
        var isMatched = false
        var id: Int
    }
}
