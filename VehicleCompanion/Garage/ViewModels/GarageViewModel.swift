//
//  GarageViewModel.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import Foundation
import SwiftData

@Observable
class GarageViewModel {
    let title = "Garage"
    let addButtonTitle = "Add"
    let garageEmptyMessage = "No vehicles added"
    var vehicles: [Vehicle] = []
    var isShowingAddSheet = false
    var vehicleDetailsViewModel: VehicleDetailsViewModel
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.vehicleDetailsViewModel = VehicleDetailsViewModel(modelContext: modelContext)
        loadVehicles()
    }
    
    func onViewAppear() {
        loadVehicles()
    }
    
    func loadVehicles() {
        do {
            vehicles = try modelContext.fetch(FetchDescriptor<Vehicle>())
        } catch {
            vehicles = []
        }
    }
    
    func onSave() {
        if vehicleDetailsViewModel.isInEditingMode {
            saveVehicle()
        } else {
            addVehicle()
        }
    }
    
    func addVehicle() {
        vehicleDetailsViewModel.addVehicle()
        loadVehicles()
        isShowingAddSheet = false
    }
    
    func deleteVehicles(at offsets: IndexSet) {
        for offset in offsets {
            let vehicle = vehicles[offset]
            modelContext.delete(vehicle)
        }
        
        try? modelContext.save()
        loadVehicles()
    }
    
    func deleteVehicle(_ vehicle: Vehicle) {
        modelContext.delete(vehicle)
        try? modelContext.save()
        loadVehicles()
    }
    
    func saveVehicle() {
        vehicleDetailsViewModel.saveVehicle()
        isShowingAddSheet = false
        loadVehicles()
    }
    
    func updateWithVehicle(_ vehicle: Vehicle) {
        vehicleDetailsViewModel.updateWithVehicle(vehicle)
        isShowingAddSheet = true
    }
}
