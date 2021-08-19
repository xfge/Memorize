//
//  ContentView.swift
//  Memorize
//
//  Created by 葛笑非 on 2021/8/18.
//

import SwiftUI

struct ContentView: View {
    @State var emojis: [String] = randomEmojis(for: ThemeType.random())
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.title)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: widthThatBestFits(cardCount: emojis.count)))], content: {
                    ForEach(emojis, id: \.self) { emoji in
                        CardView(content: emoji, isFaceUp: true)
                            .aspectRatio(2/3, contentMode: .fill)
                    }
                })
            }
            .foregroundColor(.red)
            Spacer()
            HStack {
                Spacer()
                vehicleButton
                Spacer(minLength: 50)
                fruitButton
                Spacer(minLength: 50)
                animalButton
                Spacer()
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    var vehicleButton: some View {
        Button {
            emojis = randomEmojis(for: .vehicle)
        } label: {
            VStack {
                Image(systemName: "car.fill").font(.largeTitle)
                Text("Vehicle").font(.caption)
            }
        }
    }
    
    var fruitButton: some View {
        Button {
            emojis = randomEmojis(for: .fruit)
        } label: {
            VStack {
                Image(systemName: "leaf.fill").font(.largeTitle)
                Text("Fruit").font(.caption)
            }
        }
    }
    
    var animalButton: some View {
        Button {
            emojis = randomEmojis(for: .animal)
        } label: {
            VStack {
                Image(systemName: "hare.fill").font(.largeTitle)
                Text("Animal").font(.caption)
            }
        }
    }
    
    // Extra credit 2: Smart width
    func widthThatBestFits(cardCount: Int) -> CGFloat {
        let x = CGFloat(cardCount)
        return x < 24 ? 0.35 * x * x - 13 * x + 177 : 490 / (x - 10) + 30
    }
}

struct CardView: View {
    var content: String
    @State var isFaceUp = false
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 15)
        ZStack {
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.stroke(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}


// Extra credit 1: Random number of cards
func randomEmojis(for theme: ThemeType) -> [String] {
    var emojis: [String] = []
    switch theme {
    case .vehicle:
        emojis = ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🏍", "🛺"]
    case .fruit:
        emojis = ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝", "🥑", "🫒"]
    case .animal:
        emojis = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵", "🐺", "🐗", "🐴", "🦄", "🐝", "🦋", "🐌", "🐙", "🦑", "🐡", "🐳"]
    }
    // The actual card matching game should always have an even number of cards.
    return Array(emojis.shuffled()[0..<2*Int.random(in: 2..<emojis.count/2)])
}

enum ThemeType: CaseIterable {
    case vehicle
    case animal
    case fruit
    
    static func random<G: RandomNumberGenerator>(using generator: inout G) -> ThemeType {
        return ThemeType.allCases.randomElement(using: &generator)!
    }

    static func random() -> ThemeType {
        var g = SystemRandomNumberGenerator()
        return ThemeType.random(using: &g)
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        ContentView()
            .preferredColorScheme(.dark)
    }
}
