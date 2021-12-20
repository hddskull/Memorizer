//
//  EmojiMemoryGameView.swift
//  Memorizer
//
//  Created by Max Gladkov on 08.12.2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    restart
                    Spacer()
                    shuffle
                }
                .padding(.horizontal)
            }
            deckBody
        }
        .padding()
    }
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card){
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        return !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id}){
            delay = Double(index) * ( DrawingConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: DrawingConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        return -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
        
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRation: 2/3, content: { card in
            if isUndealt(card) || card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }        })
            .foregroundColor(DrawingConstants.color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter({ isUndealt($0) })) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .frame(width: DrawingConstants.undealtWidth, height: DrawingConstants.undealtHeigth)
        .foregroundColor(DrawingConstants.color)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation(.easeInOut(duration: 0.5)) {
                game.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                game.restart()
            }
            
        }
    }
    
    private struct DrawingConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeigth: CGFloat = 90
        static let undealtWidth = undealtHeigth * aspectRatio
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    @State private var animatingBonusRemaining: Double = 0
 
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: (1 - animatingBonusRemaining) * 360 - 90))
                            .onAppear {
                                animatingBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatingBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: (1 - card.bonusRemaining) * 360 - 90))
                    }
                }
                .padding(DrawingConstants.circlePadding)
                .opacity(DrawingConstants.circleOpaque)
                 
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }.cardify(isFaceUp: card.isFaceUp)
        }

    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.75
        static let fontSize: CGFloat = 32
        static let circleOpaque: CGFloat = 0.5
        static let circlePadding: CGFloat = 5
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
//        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}
