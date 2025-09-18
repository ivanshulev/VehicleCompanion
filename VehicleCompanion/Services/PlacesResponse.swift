//
//  PlacesResponse.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import Foundation
import CoreLocation

struct PlacesResponse: Codable {
    let pois: [Place]
}

struct Place: Codable, Identifiable {
    let id: Int
    let name: String
    let url: String?
    let primaryCategoryDisplayName: String?
    let rating: Double?
    let v320x320URL: String?
    let loc: [Double]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case primaryCategoryDisplayName = "primary_category_display_name"
        case rating
        case v320x320URL = "v_320x320_url"
        case loc
    }
    
    var category: String {
        primaryCategoryDisplayName ?? "Unknown"
    }
    
    var imageURL: URL? {
        v320x320URL.flatMap { URL(string: $0) }
    }
    
    var websiteURL: URL? {
        url.flatMap { URL(string: $0) }
    }
    
    var coordinate: CLLocationCoordinate2D {
        guard let loc = loc, loc.count == 2 else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        
        return CLLocationCoordinate2D(latitude: loc[1], longitude: loc[0])
    }
}
