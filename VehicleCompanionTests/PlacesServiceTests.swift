//
//  PlacesServiceTests.swift
//  VehicleCompanionTests
//
//  Created by Ivan Shulev on 19.09.25.
//

import Testing
import Alamofire
import CoreLocation
@testable import VehicleCompanion

@MainActor
struct PlacesServiceTests {
    let placesService: PlacesService
    let session: Session

    init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        self.session = Session(configuration: configuration)
        self.placesService = PlacesService(session: session)
    }

    @Test("Fetch places returns valid data")
    func testFetchPlacesSuccess() async throws {
        let jsonString = """
            {
                "pois": [
                    {
                        "id": 1,
                        "name": "Test Name",
                        "url": "https://maps.roadtrippers.com",
                        "rating": 4.5,
                        "primary_category_display_name": "Attractions & Culture",
                        "v_320x320_url": "https://atlas-assets.roadtrippers.com/image.png",
                        "loc":[
                                    -122.4194,
                                    37.7749
                                 ],
                    }
                ]
            }
            """
        
        let data = jsonString.data(using: .utf8)!
        MockURLProtocol.stubResponse = (data: data, error: nil)

        let swCorner = CLLocationCoordinate2D(latitude: 37.7, longitude: -122.5)
        let neCorner = CLLocationCoordinate2D(latitude: 37.8, longitude: -122.4)
        let places = try await placesService.fetchPlaces(swCorner: swCorner, neCorner: neCorner)

        #expect(places.count == 1)
        let place = try #require(places.first)
        #expect(place.id == 1)
        #expect(place.name == "Test Name")
        #expect(place.category == "Attractions & Culture")
        #expect(place.rating == 4.5)
        #expect(place.imageURL?.absoluteString == "https://atlas-assets.roadtrippers.com/image.png")
        #expect(place.websiteURL?.absoluteString == "https://maps.roadtrippers.com")
        #expect(abs(place.coordinate.latitude - 37.7749) < 0.0001)
        #expect(abs(place.coordinate.longitude - (-122.4194)) < 0.0001)
    }

    @Test("Fetch places fails with invalid JSON")
    func testFetchPlacesFailure() async throws {
        let invalidJsonString = """
        {
            "invalid_key": "This is not a valid response"
        }
        """
        
        let data = invalidJsonString.data(using: .utf8)!
        MockURLProtocol.stubResponse = (data: data, error: nil)

        let swCorner = CLLocationCoordinate2D(latitude: 37.7, longitude: -122.5)
        let neCorner = CLLocationCoordinate2D(latitude: 37.8, longitude: -122.4)
        
        await #expect(throws: AFError.self) {
            _ = try await placesService.fetchPlaces(swCorner: swCorner, neCorner: neCorner)
        }
    }
}

final class MockURLProtocol: URLProtocol {
    static var stubResponse: (data: Data?, error: Error?)?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let (data, error) = MockURLProtocol.stubResponse else {
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else if let data = data {
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: "HTTP/1.1",
                                           headerFields: nil)!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
