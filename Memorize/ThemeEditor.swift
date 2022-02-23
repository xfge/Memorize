//
//  ThemeEditor.swift
//  Memorize
//
//  Created by 葛笑非 on 2022/2/20.
//

import SwiftUI

struct ThemeEditor: View {
    enum FocusField: Hashable {
      case nameField, addEmojisField, stepper, colorPicker
    }
    
    @FocusState private var focusedField: FocusField?
    
    @Binding var theme: EmojiTheme
    
    var onAdd: (() -> Void)?

    @Environment(\.isPresented) var isPresented
    @Environment(\.dismiss) var dismiss
    
    private var isAdding: Bool { onAdd != nil }
    private var isDisabled: Bool { theme.emojis.count < 2 }
    

    var body: some View {
        NavigationView {
            Form {
                nameSection
                addEmojisSection
                removeEmojiSection
                cardSettingsSection
                if theme.removedEmojis.count > 0 {
                    removedEmojisSection
                }
            }
            .navigationTitle(isAdding ? "New Theme" : "Edit \(theme.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    if isAdding {
                        Button("Add") {
                            onAdd?()
                            dismiss()
                        }
                        .disabled(isDisabled)
                    } else if isPresented, UIDevice.current.userInterfaceIdiom != .pad {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if isAdding {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    var nameSection: some View {
        Section {
            TextField("Name", text: $theme.name)
                .focused($focusedField, equals: .nameField)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .addEmojisField
                }
                .onAppear {
                    // Auto focus Name field if it's a modal to add a theme
                    if isAdding {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            self.focusedField = .nameField
                        }
                    }
                }
        } header: {
            Text("Name")
        }
    }
    
    @State private var addedEmojis: String = ""
    
    var addEmojisSection: some View {
        Section {
            TextField("", text: $addedEmojis)
                .onChange(of: addedEmojis) { newEmojis in
                    addEmojis(newEmojis)
                }
                .focused($focusedField, equals: .addEmojisField)
                .submitLabel(.done)
        } header: {
            Text("Add Emojis")
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            theme.emojis = (emojis + theme.emojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
            if isAdding {
                theme.numberOfPairs = min(theme.emojis.count, 20)
            }
        }
    }
    
    var removeEmojiSection: some View {
        Section {
            EmojiGrid(emojis: theme.emojis) {
                removeEmoji($0)
            }
        } header: {
            HStack {
                Text("Emojis in use")
                Spacer()
                Text("Tap to remove")
            }
        }
    }
    
    func removeEmoji(_ emoji: String) {
        withAnimation {
            theme.emojis.removeAll { String($0) == emoji }
            theme.numberOfPairs = min(theme.numberOfPairs, theme.emojis.count)
            theme.removedEmojis = (theme.removedEmojis + emoji).removingDuplicateCharacters
        }
    }
    
    var cardSettingsSection: some View {
        Section {
            Stepper(
                value: $theme.numberOfPairs,
                in: 2...max(2, theme.emojis.count),
                step: 1
            ) {
                Text("\(theme.numberOfPairs) pairs")
            }
            .disabled(isDisabled)
            
            ColorPicker("Color", selection: $theme.color)
        } header: {
            Text("Card")
        }
    }
    
    var removedEmojisSection: some View {
        Section {
            EmojiGrid(emojis: theme.removedEmojis) {
                restoreRemovedEmoji($0)
            } onLongPress: {
                removeRemovedEmoji($0)
            }
        } header: {
            HStack {
                Text("Removed Emojis")
                Spacer()
                Text("Tap to restore")
            }
        }
    }
    
    func removeRemovedEmoji(_ emoji: String) {
        withAnimation {
            theme.removedEmojis.removeAll { String($0) == emoji }
        }
    }
    
    func restoreRemovedEmoji(_ emoji: String) {
        withAnimation {
            addEmojis(emoji)
            removeRemovedEmoji(emoji)
        }
    }
}

struct EmojiGrid: View {
    var emojis: String
    var onTap: (String) -> Void
    var onLongPress: ((String) -> Void)? = nil
    
    private let emojiFont: Font = .system(size: 40)
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
            ForEach(emojis.removingDuplicateCharacters.map { String($0) }, id: \.self) { emoji in
                Text(emoji)
                    .onTapGesture {
                        onTap(emoji)
                    }
                    .onLongPressGesture {
                        if let onLongPress = onLongPress {
                            onLongPress(emoji)
                        }
                    }
            }
        }
        .font(emojiFont)
    }
}

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(theme: .constant(ThemeStore(name: "Preview").themes[0]))
    }
}
