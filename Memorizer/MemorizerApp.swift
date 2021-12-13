//
//  MemorizerApp.swift
//  Memorizer
//
//  Created by Max Gladkov on 08.12.2021.
//

import SwiftUI

@main
struct MemorizerApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
