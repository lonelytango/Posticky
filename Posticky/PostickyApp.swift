//
//  MarkdownStickiesApp.swift
//  MarkdownStickies
//
//  Created by Zian Chen on 10/27/25.
//

import SwiftUI
import SwiftData

@main
struct PostickyApp: App {
    var body: some Scene {
        WindowGroup("Posticky") {
            ContentView()
        }
        .windowStyle(.titleBar)
        .modelContainer(for: Note.self)
    }
}


