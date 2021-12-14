//
//  EmojiMemoryGame.swift
//  Memorizer
//
//  Created by Max Gladkov on 09.12.2021.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    static let emojis = ["☺️","🤯","🥶","🤕", "😶‍🌫️", "🤡"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { indexPair in
            return emojis[indexPair]
        }
    }
    @Published private var model = createMemoryGame()

    var cards: [Card] {
        return model.cards
    }
    
    //MARK: - Intents
    
    func choose(_ card: Card) {
        model.choose(card)
    }
}
