//
//  PokecaBoxApp.swift
//  PokecaBox
//
//  Created by 長橋和敏 on 2025/03/21.
//

import SwiftUI

@main
struct PokecaBoxApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
