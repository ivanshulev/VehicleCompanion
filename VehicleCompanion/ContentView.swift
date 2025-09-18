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
            
            PlacesView(viewModel: PlacesViewModel(placesService: PlacesService(),
                                                  modelContext: modelContext))
                .tabItem {
                    Label("Places", systemImage: "map")
                }
        }
        .navigationTitle("Vehicle Companion")
    }
}
