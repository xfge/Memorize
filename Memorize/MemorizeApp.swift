//
//  MemorizeApp.swift
//  Memorize
//
//  Created by 葛笑非 on 2021/8/18.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject private var themeStore = ThemeStore(name: "Default")
    
    var body: some Scene {
        WindowGroup {
            ThemeChooserView()
                .environmentObject(themeStore)
        }
    }
}
