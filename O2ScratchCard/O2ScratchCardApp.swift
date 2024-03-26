//
//  O2ScratchCardApp.swift
//  O2ScratchCard
//
//  Created by Tomas Korfant on 25/03/2024.
//

import SwiftUI
import SwiftData

@main
struct O2ScratchCardApp: App {

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ScratchCard.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        var cards = try? sharedModelContainer.mainContext.fetch(FetchDescriptor<ScratchCard>())
        let firstCard: ScratchCard
        if let card = cards?.first {
            firstCard = card
        } else {
            firstCard = ScratchCard()
            sharedModelContainer.mainContext.insert(firstCard)
        }

        return WindowGroup {
            ContentView(card: firstCard)
                .withErrorHandling()
        }
        .modelContainer(sharedModelContainer)
    }
}
