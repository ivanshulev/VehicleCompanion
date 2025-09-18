//
//  VehicleCompanionApp.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import SwiftUI
import SwiftData

@main
struct VehicleCompanionApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Vehicle.self, SavedPlace.self)
            setupURLCache()
        } catch {
            fatalError("Failed to create ModelContainer.")
        }
    }
    
    private func setupURLCache() {
        let memoryCapacity = 50 * 1024 * 1024
        let diskCapacity = 100 * 1024 * 1024
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "imageCache")
        URLCache.shared = cache
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }
}
