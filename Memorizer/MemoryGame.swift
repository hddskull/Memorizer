//
//  MemoryGame.swift
//  Memorizer
//
//  Created by Max Gladkov on 09.12.2021.
//

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: Array<Card>
    
    private var indexOfTheOnlyCardFaceUp: Int? {
        get { cards.indices.filter { cards[$0].isFaceUP }.oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUP = ($0 == newValue) }}
    }
    
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
            cards[chosenIndex].isFaceUP = true
        }
        else {
            indexOfTheOnlyCardFaceUp = chosenIndex
        }
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
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
    }
    
    struct Card: Identifiable {
        var isFaceUP = true
        var isMatched = false
        let content: CardContent
        let id: Int
    }
    
}

extension Array {
    var oneAndOnly: Element? {
        if self.count == 1 {
            return self.first
        } else {
            return nil
        }
    }
}

struct MemoryGame_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
