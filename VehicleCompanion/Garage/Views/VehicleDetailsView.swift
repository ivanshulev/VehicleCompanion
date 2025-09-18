//
//  VehicleDetailsView.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import SwiftUI

struct VehicleDetailsView: View {
    @Binding var vehicle: Vehicle
    let navigationTitle: String
    let onSave: () -> Void
    let onCancel: () -> Void
    @State private var isShowingImagePicker = false
    @State private var imageData: Data?
    @FocusState private var focusedField: Field?
    
    private enum Field: Hashable {
        case name, make, model, year, vin
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Nickname", text: $vehicle.name)
                        .focused($focusedField, equals: .name)
                    
                    TextField("Make", text: $vehicle.make)
                        .focused($focusedField, equals: .make)
                    
                    TextField("Model", text: $vehicle.model)
                        .focused($focusedField, equals: .model)
                    
                    TextField("Year", value: $vehicle.year, format: .number)
                        .focused($focusedField, equals: .year)
                        .keyboardType(.numberPad)
                    
                    TextField("VIN", text: $vehicle.vin)
                        .focused($focusedField, equals: .vin)
                        .textInputAutocapitalization(.characters)
                    
                    Picker("Fuel Type", selection: $vehicle.fuelType) {
                        Text("Gasoline").tag(Vehicle.FuelType.gasoline.rawValue)
                        Text("Electric").tag(Vehicle.FuelType.electric.rawValue)
                        Text("Hybrid").tag(Vehicle.FuelType.hybrid.rawValue)
                    }
                }
                
                Section("Photo") {
                    Button("Pick Photo") {
                        focusedField = nil
                        isShowingImagePicker = true
                    }
                    if let data = imageData ?? vehicle.imageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        vehicle.imageData = imageData
                        onSave()
                    }
                    .disabled(vehicle.name.isEmpty || vehicle.make.isEmpty)
                }
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(imageData: $imageData)
            }
        }
    }
}
