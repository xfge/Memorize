//
//  ThemeManagerView.swift
//  Memorize
//
//  Created by 葛笑非 on 2022/2/20.
//

import SwiftUI

struct ThemeChooserView: View {
    
    @EnvironmentObject var store: ThemeStore
    
    @State var games: [UUID: EmojiMemoryGame] = [:]
    
    @State private var editMode: EditMode = .inactive

    @State private var themeToEdit: EmojiTheme?
    @State private var themeToAdd: EmojiTheme?

    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    if let game = game(for: theme) {
                        ThemeItemView(game: game, theme: theme)
                            .gesture(editMode == .active ? tap(on: theme) : nil)
                    }
                }
                .onDelete { store.themes.remove(atOffsets: $0) }
                .onMove { store.themes.move(fromOffsets: $0, toOffset: $1) }
            }
            .navigationTitle("Memorize")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .primaryAction) {
                    addButton
                }
            }
            .sheet(item: $themeToEdit) {
                editMode = .inactive
            } content: { theme in
                ThemeEditor(theme: $store.themes[theme])
                    .onChange(of: store.themes[theme]) { newTheme in
                        games[theme.id] = EmojiMemoryGame(theme: newTheme)
                    }
            }
            .sheet(item: $themeToAdd, content: { theme in
                ThemeEditor(theme: $themeToAdd ?? EmojiTheme(name: "", emojis: "", color: .blue)) {
                    if let theme = themeToAdd {
                        store.themes.append(theme)
                    }
                }
            })
            .environment(\.editMode, $editMode)
        }
    }
    
    var addButton: some View {
        Button {
            themeToAdd = EmojiTheme(name: "", emojis: "", color: .blue)
        } label: {
            Image(systemName: "plus")
        }
    }

    func tap(on theme: EmojiTheme) -> some Gesture {
        TapGesture().onEnded {
            themeToEdit = theme
        }
    }
    
    func game(for theme: EmojiTheme) -> EmojiMemoryGame? {
        if games[theme.id] == nil {
            games[theme.id] = EmojiMemoryGame(theme: theme)
        }
        return games[theme.id]
    }
}

struct ThemeItemView: View {
    @ObservedObject var game: EmojiMemoryGame
    var theme: EmojiTheme
    
    var emojiCount: Int { theme.emojis.count }
    var sampleEmojis: String { Array(theme.emojis)[0..<min(emojiCount, 6)].reduce("") { "\($0)" + "\($1)" } }
    
    var body: some View {
        NavigationLink {
            EmojiMemoryGameView(game: game)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(theme.name)
                        .font(.body)
                    Spacer()
                    Text(String(theme.numberOfPairs))
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(theme.color)
                }
                .padding([.trailing], 3)
                HStack {
                    Text(sampleEmojis)
                    if emojiCount > 6 {
                        Text("+\(emojiCount - 6)")
                    }
                    Spacer()
                    if game.ongoing {
                        Image(systemName: "clock")
                    }
                }
            }
            .font(.footnote)
        }
    }
}

struct ThemeManagerView_Previews: PreviewProvider {
    static var previews: some View {
        let store = ThemeStore(name: "Preview")
        ThemeChooserView()
            .environmentObject(store)
        ThemeItemView(game: EmojiMemoryGame(theme: store.themes[0]), theme: store.themes[0])
    }
}
