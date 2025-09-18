//
//  Vehicle.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import Foundation
import SwiftData

@Model
class Vehicle {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var make: String
    var model: String
    var year: Int
    var vin: String
    var fuelType: String
    var imageData: Data?
    
    enum FuelType: String {
        case gasoline
        case electric
        case hybrid
    }
    
    init(name: String, make: String, model: String, year: Int, vin: String, fuelType: FuelType, imageData: Data? = nil) {
        self.name = name
        self.make = make
        self.model = model
        self.year = year
        self.vin = vin
        self.fuelType = fuelType.rawValue
        self.imageData = imageData
    }
}

extension Vehicle {
    convenience init() {
        self.init(name: "", make: "", model: "", year: 2022, vin: "", fuelType: .gasoline)
    }
}
