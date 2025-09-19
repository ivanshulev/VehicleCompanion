//
//  PlacesViewModelTests.swift
//  VehicleCompanionTests
//
//  Created by Ivan Shulev on 19.09.25.
//

import XCTest
import MapKit
import SwiftData
import Combine
@testable import VehicleCompanion

@MainActor
class PlacesViewModelTests: XCTestCase {
    var viewModel: PlacesViewModel!
    var mockPlacesService: MockPlacesService!
    var modelContainer: ModelContainer!
    var centerCoordinate: CLLocationCoordinate2D!
    
    override func setUp() async throws {
        try await super.setUp()
        
        let schema = Schema([SavedPlace.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: schema, configurations: configuration)
        
        mockPlacesService = MockPlacesService()
        centerCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        viewModel = PlacesViewModel(placesService: mockPlacesService,
                                  modelContext: modelContainer.mainContext,
                                  centerCoordinate: centerCoordinate)
    }
    
    override func tearDown() async throws {
        viewModel = nil
        mockPlacesService = nil
        modelContainer = nil
        centerCoordinate = nil
        try await super.tearDown()
    }
    
    func testFilteredPlacesReturnsPlaces() async {
        let place = Place(id: 1,
                          name: "Test Place",
                          url: "https://example.com",
                          primaryCategoryDisplayName: "sample category",
                          rating: 4.5,
                          v320x320URL: nil,
                          loc: [10, -10])
        mockPlacesService.fetchPlacesResult = .success([place])
        viewModel.isShowingOnlySavedPlaces = false
        
        await viewModel.loadPlaces()
        let filteredPlaces = viewModel.filteredPlaces
        
        XCTAssertEqual(filteredPlaces, [place])
    }
    
    func testFilteredPlacesReturnsSavedPlaces() async {
        let savedPlace = SavedPlace(id: 1,
                                    name: "Test Place",
                                    category: "sample category",
                                    rating: 4.5,
                                    latitude: 10,
                                    longitude: -10,
                                    imageURL: nil,
                                    url: nil)
        modelContainer.mainContext.insert(savedPlace)
        try? modelContainer.mainContext.save()
        viewModel.loadSavedPlaces()
        viewModel.isShowingOnlySavedPlaces = true
        
        let filteredPlaces = viewModel.filteredPlaces
        XCTAssertEqual(filteredPlaces, [savedPlace.toPlace()])
    }
    
    func testFilteredPlacesEmptyPlaces() async {
        mockPlacesService.fetchPlacesResult = .success([])
        viewModel.isShowingOnlySavedPlaces = false
        
        await viewModel.loadPlaces()
        let filteredPlaces = viewModel.filteredPlaces
        
        XCTAssertTrue(filteredPlaces.isEmpty)
    }
    
    func testFilteredPlacesEmptySavedPlaces() async {
        viewModel.isShowingOnlySavedPlaces = true
        viewModel.savedPlaces = []
        
        let filteredPlaces = viewModel.filteredPlaces
        XCTAssertTrue(filteredPlaces.isEmpty)
    }
    
    func testFilteredPlacesWithBothPopulated() async {
        let place1 = Place(id: 1,
                          name: "Test Place 1",
                          url: "https://example.com",
                          primaryCategoryDisplayName: "sample category",
                          rating: 4.5,
                          v320x320URL: nil,
                          loc: [10, -10])
        let place2 = Place(id: 2,
                          name: "Test Place 2",
                          url: "https://example.com",
                          primaryCategoryDisplayName: "sample category",
                          rating: 4.5,
                          v320x320URL: nil,
                          loc: [10, -10])
        let savedPlace = SavedPlace(id: 3,
                                    name: "Test Place 3",
                                    category: "sample category",
                                    rating: 4.5,
                                    latitude: 10,
                                    longitude: -10,
                                    imageURL: nil,
                                    url: nil)
        mockPlacesService.fetchPlacesResult = .success([place1, place2])
        modelContainer.mainContext.insert(savedPlace)
        try? modelContainer.mainContext.save()
        viewModel.loadSavedPlaces()
        
        await viewModel.loadPlaces()
        viewModel.isShowingOnlySavedPlaces = true
        let filteredSavedPlaces = viewModel.filteredPlaces
        
        XCTAssertEqual(filteredSavedPlaces, [savedPlace.toPlace()])
        XCTAssertEqual(filteredSavedPlaces.count, 1)
        
        viewModel.isShowingOnlySavedPlaces = false
        let filteredAllPlaces = viewModel.filteredPlaces
        
        XCTAssertEqual(filteredAllPlaces, [place1, place2])
        XCTAssertEqual(filteredAllPlaces.count, 2)
    }
}

class MockPlacesService: PlacesServiceType {
    var fetchPlacesResult: Result<[Place], Error>?
    
    func fetchPlaces(swCorner: CLLocationCoordinate2D, neCorner: CLLocationCoordinate2D) async throws -> [Place] {
        if let result = fetchPlacesResult {
            return try result.get()
        }
        return []
    }
}
