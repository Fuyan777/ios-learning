//
//  GymMemoApp.swift
//  GymMemo
//
//  Created by Fuya Yamada on 2025/10/14.
//

import SwiftUI
import SwiftData

@main
struct GymMemoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WorkoutRecord.self,
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
