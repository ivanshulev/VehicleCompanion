//
//  VehicleDetailsViewModel.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import Foundation
import SwiftData

@Observable
class VehicleDetailsViewModel {
    var editingVehicle: Vehicle?
    var newVehicle = Vehicle()
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addVehicle() {
        guard isPopulated else {
            return
        }
        
        modelContext.insert(newVehicle)
        try? modelContext.save()
        newVehicle = Vehicle()
    }
    
    func updateWithVehicle(_ vehicle: Vehicle) {
        editingVehicle = vehicle
        newVehicle = vehicle
    }
    
    func saveVehicle() {
        editingVehicle?.name = newVehicle.name
        editingVehicle?.make = newVehicle.make
        editingVehicle?.model = newVehicle.model
        editingVehicle?.year = newVehicle.year
        editingVehicle?.vin = newVehicle.vin
        editingVehicle?.fuelType = newVehicle.fuelType
        editingVehicle?.imageData = newVehicle.imageData
        
        try? modelContext.save()
        editingVehicle = nil
    }
    
    var navigationTitle: String {
        isInEditingMode ? "Edit Vehicle" : "Add Vehicle"
    }
    
    var isInEditingMode: Bool {
        editingVehicle != nil
    }
    
    private var isPopulated: Bool {
        return !newVehicle.name.isEmpty && !newVehicle.make.isEmpty
    }
}
