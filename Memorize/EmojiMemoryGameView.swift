//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by 葛笑非 on 2021/8/18.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    @State private var dealt = Set<Int>()
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    restartButton
                    Spacer()
                    shuffleButton
                }
            }
            deckBody
        }
        .padding()
        .navigationTitle(game.themeName)
        .toolbar {
            Text("Points: \(game.points)")
        }
        .onAppear {
            if game.ongoing {
                dealt = Set<Int>(game.cards.map { $0.id })
            }
        }
        .alert("Congratulations!", isPresented: $isAlertPresented) {
            Button("Restart") {
                restart()
            }
        } message: {
            Text("You've got \(game.points) points.")
        }
    }
    
    @State private var isAlertPresented: Bool = false

    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        tap(on: card)
                    }
            }
        }
        .foregroundColor(game.themeColor)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(game.themeColor)
        .onTapGesture {
            dealCards()
        }
    }
    
    func tap(on card: EmojiMemoryGame.Card) {
        withAnimation {
            game.choose(card)
            if game.isSuccessMatch  {
                TapticEngine.notification.feedback(.success)
            } else {
                TapticEngine.selection.feedback()
            }
            if game.isGameCompleted {
                isAlertPresented = true
                game.completeGame()
            }
        }
    }
    
    func dealCards() {
        TapticEngine.impact.feedback(.light)
        game.start()
        for card in game.cards {
            withAnimation(dealAnimation(for: card)) {
                deal(card)
            }
        }
    }
    
    var shuffleButton: some View {
        Button("Shuffle") {
            TapticEngine.impact.feedback(.light)
            withAnimation {
                game.shuffle()
            }
        }
        .disabled(dealt.isEmpty)
    }
    
    var restartButton: some View {
        Button("Restart") {
            restart()
        }
        .disabled(dealt.isEmpty)
    }
    
    func restart() {
        TapticEngine.impact.feedback(.medium)
        withAnimation {
            dealt = []
            game.restart()
        }
    }
    
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    @State var animatedBonusRemaining: Double = 0
    @State var rotationDegree: Double = 0
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 360*(1-animatedBonusRemaining)-90))
                            .onAppear() {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 360*(1-card.bonusRemaining)-90))
                    }
                }
                    .padding(DrawingConstants.piePadding)
                    .opacity(DrawingConstants.pieOpacity)
                Text(card.content)
                    .rotationEffect(Angle.degrees(rotationDegree))
                    .padding(5)
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
                    .onChange(of: card.isMatched) { isMatched in
                        withAnimation(isMatched ? .linear(duration: 1).repeatForever(autoreverses: false) : .default) {
                            rotationDegree = isMatched ? 360 : 0
                        }
                    }
            }
            .cardify(isFaceUp: card.isFaceUp)
        })
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) * DrawingConstants.fontScale / DrawingConstants.fontSize
    }
    
    private struct DrawingConstants {
        static let fontSize: CGFloat = 32
        static let fontScale: CGFloat = 0.7
        static let piePadding: CGFloat = 5
        static let pieOpacity: Double = 0.5
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame(theme: ThemeStore(name: "Preview").themes[0])
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}
