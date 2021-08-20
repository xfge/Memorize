//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by 葛笑非 on 2021/8/18.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        ScrollView {
            HStack{
                Text("\(viewModel.themeName): \(viewModel.points)").font(.title)
                Spacer()
                Button(action: {
                    viewModel.restart()
                }, label: {
                    Text("New Game")
                })
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card, hasGradientBackground: viewModel.themeName == "Flag")
                        .aspectRatio(2/3, contentMode: .fill)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
            .foregroundColor(viewModel.color)
        }
        .padding(.horizontal)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var hasGradientBackground = false
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 15)
        ZStack {
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.stroke(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                // Extra credit 3: Support a gradient as the “color” for a theme
                if (hasGradientBackground) {
                    shape.fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .top, endPoint: .bottom))
                } else {
                    shape.fill()
                }
            }
        }
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(viewModel: game)
            .preferredColorScheme(.light)
        EmojiMemoryGameView(viewModel: game)
            .preferredColorScheme(.dark)
    }
}
