//
//  SavedPlace.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import Foundation
import SwiftData
import CoreLocation

@Model
class SavedPlace {
    @Attribute(.unique) var id: Int
    var name: String
    var category: String
    var rating: Double?
    var latitude: Double
    var longitude: Double
    var imageURL: URL?
    var url: URL?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(id: Int, name: String, category: String, rating: Double?, latitude: Double, longitude: Double, imageURL: URL?, url: URL?) {
        self.id = id
        self.name = name
        self.category = category
        self.rating = rating
        self.latitude = latitude
        self.longitude = longitude
        self.imageURL = imageURL
        self.url = url
    }
    
    func toPlace() -> Place {
        Place(id: id,
              name: name,
              url: url?.absoluteString,
              primaryCategoryDisplayName: category,
              rating: rating,
              v320x320URL: imageURL?.absoluteString,
              loc: [latitude, longitude])
    }
}
