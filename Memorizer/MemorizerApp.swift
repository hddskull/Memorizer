//
//  MemorizerApp.swift
//  Memorizer
//
//  Created by Max Gladkov on 08.12.2021.
//

import SwiftUI

@main
struct MemorizerApp: App {
    private let game = EmojiMemoryGame()
    private let document = EmojiArtDocument()
    
    var body: some Scene {
        WindowGroup {
//            EmojiMemoryGameView(game: game)
            EmojiArtDocumentView(document: document)
        }
    }
}
