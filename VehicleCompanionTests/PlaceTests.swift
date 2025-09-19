//
//  PlaceTests.swift
//  VehicleCompanionTests
//
//  Created by Ivan Shulev on 19.09.25.
//

import Testing
import Foundation
@testable import VehicleCompanion

@Suite("Place Tests")
struct PlaceTests {
    @Test("Decoding valid response")
    func testPlacesResponseDecoding() async throws {
        let validJSON = """
            {
                "pois": [
                    {
                        "id": 1,
                        "name": "Cincinnati Museum Center",
                        "url": "https://maps.roadtrippers.com/us/cincinnati-oh/attractions/cincinnati-museum-center",
                        "rating": 4.5,
                        "primary_category_display_name": "Attractions & Culture",
                        "v_320x320_url": "https://atlas-assets.roadtrippers.com/uploads/place_image/image/1026827998/-strip_-quality_60_-interlace_Plane_-resize_320x320_U__-gravity_center_-extent_320x320/place_image-image-2ea174a8-c719-45f8-bc23-d91102a96163.jpg",
                        "loc":[
                                    -84.537158,
                                    39.109946
                                 ],
                    },
                    {
                        "id": 2,
                        "name": "National Underground Railroad Freedom Center",
                        "url": null,
                        "primary_category_display_name": null,
                        "rating": null,
                        "v_320x320_url": null,
                        "loc":[
                                    -84.5111032,
                                    39.0970834
                                 ],
                    }
                ]
            }
            """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(PlacesResponse.self, from: validJSON)
        
        #expect(response.pois.count == 2, "Should decode two places")
        
        let place1 = response.pois[0]
        #expect(place1.id == 1, "First place id should be 1")
        #expect(place1.name == "Cincinnati Museum Center", "First place name should match")
        #expect(place1.url == "https://maps.roadtrippers.com/us/cincinnati-oh/attractions/cincinnati-museum-center", "First place url should match")
        #expect(place1.primaryCategoryDisplayName == "Attractions & Culture", "First place category should match")
        #expect(place1.rating == 4.5, "First place rating should match")
        #expect(place1.v320x320URL == "https://atlas-assets.roadtrippers.com/uploads/place_image/image/1026827998/-strip_-quality_60_-interlace_Plane_-resize_320x320_U__-gravity_center_-extent_320x320/place_image-image-2ea174a8-c719-45f8-bc23-d91102a96163.jpg", "First place image URL should match")
        #expect(place1.loc == [-84.537158, 39.109946], "First place coordinates should match")
        
        let place2 = response.pois[1]
        #expect(place2.id == 2, "Second place id should be 2")
        #expect(place2.name == "National Underground Railroad Freedom Center", "Second place name should match")
        #expect(place2.url == nil, "Second place URL should be nil")
        #expect(place2.primaryCategoryDisplayName == nil, "Second place category should be nil")
        #expect(place2.rating == nil, "Second place rating should be nil")
        #expect(place2.v320x320URL == nil, "Second place image url should be nil")
        #expect(place2.loc == [-84.5111032, 39.0970834], "Second place coordinates should match")
    }
    
    @Test("Encoding and decoding")
    func testPlaceEncodingDecoding() async throws {
        let place = Place(id: 1,
                          name: "Cincinnati Museum Center",
                          url: "https://maps.roadtrippers.com/us/cincinnati-oh/attractions/cincinnati-museum-center",
                          primaryCategoryDisplayName: "Attractions & Culture",
                          rating: 4.5,
                          v320x320URL: "https://atlas-assets.roadtrippers.com/uploads/place_image/image/1026827998/-strip_-quality_60_-interlace_Plane_-resize_320x320_U__-gravity_center_-extent_320x320/place_image-image-2ea174a8-c719-45f8-bc23-d91102a96163.jpg",
                          loc: [-10, 10])
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encodedData = try encoder.encode(place)
        let decodedPlace = try decoder.decode(Place.self, from: encodedData)
        
        #expect(decodedPlace.id == place.id, "IDs should match")
        #expect(decodedPlace.name == place.name, "Names should match")
        #expect(decodedPlace.url == place.url, "URLs should match")
        #expect(decodedPlace.primaryCategoryDisplayName == place.primaryCategoryDisplayName, "Categories should match")
        #expect(decodedPlace.rating == place.rating, "Ratings should match")
        #expect(decodedPlace.v320x320URL == place.v320x320URL, "Image URLs should match")
        #expect(decodedPlace.loc == place.loc, "Coordinates should match")
    }
    
    @Test("Decoding invalid JSON")
    func testPlaceDecodingWithInvalidJSON() async throws {
        let invalidJSON = """
            {
                "pois": [
                    {
                        "id": "text",
                        "name": "Invalid Place"
                    }
                ]
            }
            """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        #expect(throws: DecodingError.self, performing: {
            try decoder.decode(PlacesResponse.self, from: invalidJSON)
        })
    }
    
    @Test("Computed properties")
    func testPlaceComputedProperties() async throws {
        let place = Place(
            id: 1,
            name: "Cincinnati Museum Center",
            url: "https://maps.roadtrippers.com/us/cincinnati-oh/attractions/cincinnati-museum-center",
            primaryCategoryDisplayName: "Attractions & Culture",
            rating: 4.5,
            v320x320URL: "https://atlas-assets.roadtrippers.com/uploads/place_image/image/1026827998/-strip_-quality_60_-interlace_Plane_-resize_320x320_U__-gravity_center_-extent_320x320/place_image-image-2ea174a8-c719-45f8-bc23-d91102a96163.jpg",
            loc: [-10, 10]
        )
        
        #expect(place.category == "Attractions & Culture", "Category should match primaryCategoryDisplayName")
        
        #expect(place.imageURL == URL(string: "https://atlas-assets.roadtrippers.com/uploads/place_image/image/1026827998/-strip_-quality_60_-interlace_Plane_-resize_320x320_U__-gravity_center_-extent_320x320/place_image-image-2ea174a8-c719-45f8-bc23-d91102a96163.jpg"),
                "imageURL should convert string to URL")
        
        #expect(place.websiteURL == URL(string: "https://maps.roadtrippers.com/us/cincinnati-oh/attractions/cincinnati-museum-center"),
                "websiteURL should convert string to URL")
        
        #expect(place.coordinate.latitude == 10, "Coordinate latitude should match loc[1]")
        #expect(place.coordinate.longitude == -10, "Coordinate latitude should match loc[0]")
    }
    
    @Test("Computed properties with nil values")
    func testPlaceComputedPropertiesWithNilValues() async throws {
        let place = Place(
            id: 2,
            name: "Exhibition Center",
            url: nil,
            primaryCategoryDisplayName: nil,
            rating: nil,
            v320x320URL: nil,
            loc: nil
        )
        
        #expect(place.category == "Unknown", "Category should be 'Unknown' when primaryCategoryDisplayName is nil")
        #expect(place.imageURL == nil, "imageURL should be nil when v320x320URL is nil")
        #expect(place.websiteURL == nil, "websiteURL should be nil when url is nil")
        #expect(place.coordinate.latitude == 0, "Coordinate latitude should be 0 when loc is nil")
        #expect(place.coordinate.longitude == 0, "Coordinate longitude should be 0 when loc is nil")
    }
    
    @Test("Test with invalid loc array")
    func testPlaceCoordinateWithInvalidLoc() async throws {
        let place = Place(
            id: 10,
            name: "Invalid Place",
            url: nil,
            primaryCategoryDisplayName: nil,
            rating: nil,
            v320x320URL: nil,
            loc: [1.0]
        )
        
        #expect(place.coordinate.latitude == 0, "Coordinate latitude should be 0 for invalid loc")
        #expect(place.coordinate.longitude == 0, "Coordinate longitude should be 0 for invalid loc")
    }
}
