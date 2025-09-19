//
//  POIService.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import Foundation
import Alamofire
import CoreLocation

protocol PlacesServiceType {
    func fetchPlaces(swCorner: CLLocationCoordinate2D, neCorner: CLLocationCoordinate2D) async throws -> [Place]
}

class PlacesService: PlacesServiceType {
    private let baseURL = "https://api2.roadtrippers.com/api/v2/pois/discover"
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func fetchPlaces(swCorner: CLLocationCoordinate2D, neCorner: CLLocationCoordinate2D) async throws -> [Place] {
        let parameters: Parameters = [
            "sw_corner": "\(swCorner.longitude),\(swCorner.latitude)",
            "ne_corner": "\(neCorner.longitude),\(neCorner.latitude)",
            "page_size": 50
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(baseURL, parameters: parameters)
                .validate()
                .responseDecodable(of: PlacesResponse.self) { response in
                    switch response.result {
                    case .success(let poiResponse):
                        continuation.resume(returning: poiResponse.pois)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
