//
//  ContentView.swift
//  GymMemo
//
//  Created by Fuya Yamada on 2025/10/14.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            WorkoutHomeView()
                .tabItem {
                    Label("ホーム", systemImage: "house.fill")
                }
            
            StatisticsView()
                .tabItem {
                    Label("統計", systemImage: "chart.bar.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: WorkoutRecord.self, inMemory: true)
}
