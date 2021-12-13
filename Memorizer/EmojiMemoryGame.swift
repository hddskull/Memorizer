//
//  EmojiMemoryGame.swift
//  Memorizer
//
//  Created by Max Gladkov on 09.12.2021.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    static let emojis = ["☺️","🤯","🥶","🤕", "😶‍🌫️", "🤡"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { indexPair in
            return emojis[indexPair]
        }
    }
    @Published private var model: MemoryGame<String> = createMemoryGame()

    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    
    //MARK: - Intents
    
    func choose(_ card: MemoryGame<String>.Card){
        model.choose(card)
    }
}
