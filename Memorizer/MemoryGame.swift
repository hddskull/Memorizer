//
//  MemoryGame.swift
//  Memorizer
//
//  Created by Max Gladkov on 09.12.2021.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: Array<Card>
    
    private var indexOfTheOnlyCardFaceUp: Int?
    
    mutating func choose(_ card: Card) {
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id}),
              !cards[chosenIndex].isFaceUP,
              !cards[chosenIndex].isMatched
        else { return }
        
        if let potentialMatchIndex = indexOfTheOnlyCardFaceUp {
            if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                cards[chosenIndex].isMatched = true
                cards[potentialMatchIndex].isMatched = true
            }
            indexOfTheOnlyCardFaceUp = nil
        }
        else {
            for index in cards.indices {
                cards[index].isFaceUP = false
            }
            indexOfTheOnlyCardFaceUp = chosenIndex
        }
        cards[chosenIndex].isFaceUP.toggle()
    }
    
    func index(of card: Card) -> Int? {
        for index in 0..<cards.count {
            if cards[index].id == card.id {
                return index
            }
        }
        return nil
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
    }
    
    struct Card: Identifiable {
        var isFaceUP: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
    
}
