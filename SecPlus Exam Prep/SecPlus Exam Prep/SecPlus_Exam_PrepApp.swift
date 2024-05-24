//
//  SecPlus_Exam_PrepApp.swift
//  SecPlus Exam Prep
//
//  Created by Craig Opie on 5/24/24.
//

import SwiftUI
import SwiftData

@main
struct SecPlus_Exam_PrepApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
