//
//  ContentView.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    var body: some View {
        TabView {
            GarageView(viewModel: GarageViewModel(modelContext: modelContext))
                .tabItem {
                    Label("Garage", systemImage: "car")
                }
        }
        .navigationTitle("Vehicle Companion")
    }
}
