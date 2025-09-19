//
//  PlacesViewModel.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import Foundation
import SwiftData
import MapKit
import Observation
import Combine

@Observable
class PlacesViewModel {
    private let placesService: PlacesServiceType
    private let modelContext: ModelContext
    let centerCoordinateSubject = PassthroughSubject<CLLocationCoordinate2D, Never>()
    var centerCoordinate: CLLocationCoordinate2D
    var region: MKCoordinateRegion
    private var places: [Place] = []
    var savedPlaces: [SavedPlace] = []
    var selectedTab: PlaceTab = .list
    var selectedPlace: Place?
    var isShowingOnlySavedPlaces = false
    var viewState: ViewState = .inProgress
    var isShowingDetail = false
    private var cancellables = Set<AnyCancellable>()
    
    let navigationTitle = "Places"
    let progressStateMessage = "Loading places..."
    let retryButtonTitle = "Retry"
    let noPlacesMessage = "No places found"
    let refreshButtonTitle = "Refresh"
    let searchButtonTitle = "Search Area"
    
    enum PlaceTab: String, CaseIterable {
        case list = "List"
        case map = "Map"
    }
    
    enum ViewState {
        case inProgress
        case failure(String)
        case successful
    }
    
    init(placesService: PlacesServiceType,
         modelContext: ModelContext,
         centerCoordinate: CLLocationCoordinate2D) {
        self.placesService = placesService
        self.modelContext = modelContext
        self.centerCoordinate = centerCoordinate
        self.region = MKCoordinateRegion(center: centerCoordinate,
                                         span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        setupRequestsSequence()
        loadSavedPlaces()
    }
    
    func searchForPlaces() {
        self.region = MKCoordinateRegion(center: centerCoordinate,
                                         span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        centerCoordinateSubject.send(centerCoordinate)
    }
    
    func setupRequestsSequence() {
        centerCoordinateSubject
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] newCoordinate in
                guard let self else {
                    return
                }
                
                Task {
                    await self.loadPlacesSilently()
                }
            }
            .store(in: &cancellables)
    }
    
    var filteredPlaces: [Place] {
        isShowingOnlySavedPlaces ? savedPlaces.map({ $0.toPlace() }) : places
    }
    
    func loadPlaces() async {
        viewState = .inProgress
        
        do {
            let (swCorner, neCorner) = calculateCornersOf(region: region)
            places = try await placesService.fetchPlaces(swCorner: swCorner, neCorner: neCorner)
            viewState = .successful
        } catch {
            viewState = .failure("Failed to load places")
            places = []
        }
    }
    
    private func loadPlacesSilently() async {
        do {
            let (swCorner, neCorner) = calculateCornersOf(region: region)
            let places = try await placesService.fetchPlaces(swCorner: swCorner, neCorner: neCorner)
            
            if !places.isEmpty {
                self.places = places
            }
        } catch {
        }
    }
    
    func loadSavedPlaces() {
        do {
            savedPlaces = try modelContext.fetch(FetchDescriptor<SavedPlace>())
        } catch {
            savedPlaces = []
        }
    }
    
    func toggleSave(_ place: Place) {
        if let existing = savedPlaces.first(where: { $0.id == place.id }) {
            modelContext.delete(existing)
        } else {
            let saved = SavedPlace(id: place.id,
                                   name: place.name,
                                   category: place.category,
                                   rating: place.rating,
                                   latitude: place.coordinate.latitude,
                                   longitude: place.coordinate.longitude,
                                   imageURL: place.imageURL,
                                   url: place.websiteURL)
            modelContext.insert(saved)
        }
        
        try? modelContext.save()
        loadSavedPlaces()
    }
    
    func isSaved(_ place: Place) -> Bool {
        savedPlaces.contains { $0.id == place.id }
    }
    
    private func calculateCornersOf(region: MKCoordinateRegion) -> (CLLocationCoordinate2D, CLLocationCoordinate2D) {
        let latDelta = region.span.latitudeDelta / 2.0
        let lonDelta = region.span.longitudeDelta / 2.0
        
        let swCorner = CLLocationCoordinate2D(
            latitude: region.center.latitude - latDelta,
            longitude: region.center.longitude - lonDelta
        )
        
        let neCorner = CLLocationCoordinate2D(
            latitude: region.center.latitude + latDelta,
            longitude: region.center.longitude + lonDelta
        )
        
        return (swCorner, neCorner)
    }
    
    private func isSignificantChange(from old: CLLocationCoordinate2D, to new: CLLocationCoordinate2D) -> Bool {
        let latDiff = abs(new.latitude - old.latitude)
        let lonDiff = abs(new.longitude - old.longitude)
        let threshold = 0.001
        return latDiff > threshold || lonDiff > threshold
    }
}
