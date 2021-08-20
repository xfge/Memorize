//
//  MemoryGame.swift
//  Memorize
//
//  Created by 葛笑非 on 2021/8/19.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private(set) var points = 0
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    private var lastCardChosenAt = Date()
    private var cardViewNumbers: [Int: Int] = [:]
    
    init(numberOfPairsOfCards: Int, createCard: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCard(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        // Hint 15: shuffle arrays
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        if let cardIndex = cards.firstIndex(where: { $0.id == card.id }), !card.isMatched, !card.isFaceUp {
            if let indexOfPotentialMatchCard = indexOfTheOneAndOnlyFaceUpCard {
                // Extra credit 4: Give more points for choosing cards more quickly; Deduct more points for mismatching seen cards (more times the card is viewed, more points deducted)
                let factor = max(10 - Int(Date().timeIntervalSince(lastCardChosenAt)), 1)
                if (cards[indexOfPotentialMatchCard].content == card.content) {
                    cards[indexOfPotentialMatchCard].isMatched = true
                    cards[cardIndex].isMatched = true
                    points += 2 * factor
                } else {
                    for index in [cardIndex, indexOfPotentialMatchCard] {
                        if let viewNumber = cardViewNumbers[index] {
                            points -= 2 * viewNumber
                        }
                    }
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                for cardIndex in cards.indices {
                    // Hint 19: Track the card when it turned from face up to face down.
                    if (cards[cardIndex].isFaceUp) {
                        cardViewNumbers[cardIndex] = 1 + (cardViewNumbers[cardIndex] ?? 0)
                    }
                    cards[cardIndex].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = cardIndex
            }
            cards[cardIndex].isFaceUp = true
            lastCardChosenAt = Date()
        }
    }
    
    struct Card: Identifiable, Hashable {
        var content: CardContent
        var isFaceUp = false
        var isMatched = false
        var id: Int
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
