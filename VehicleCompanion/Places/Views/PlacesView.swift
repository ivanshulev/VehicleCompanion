//
//  PlacesView.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import SwiftUI
import MapKit
import SwiftData

struct PlacesView: View {
    @State private var viewModel: PlacesViewModel
    @State private var isSavedSelected = false
    
    init(viewModel: PlacesViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .inProgress:
                    ProgressView(viewModel.progressStateMessage)
                case .failure(let message):
                    PlacesErrorView(message: message, retryButtonTitle: viewModel.retryButtonTitle) {
                        Task { await viewModel.loadPlaces() }
                    }
                case .successful:
                    if viewModel.filteredPlaces.isEmpty {
                        PlacesEmptyView(message: viewModel.noPlacesMessage,
                                        refreshButtonTitle: viewModel.refreshButtonTitle) {
                            Task { await viewModel.loadPlaces() }
                        }
                    } else {
                        VStack {
                            Button(action: {
                                viewModel.searchForPlaces()
                            }) {
                                Text(viewModel.searchButtonTitle)
                            }
                            
                            segmentedControl()
                            
                            Group {
                                if viewModel.selectedTab == .list {
                                    PlacesListView(viewModel: viewModel)
                                } else {
                                    MapView(viewModel: viewModel)
                                }
                            }
                        }
                        .sheet(isPresented: $viewModel.isShowingDetail) {
                            if let place = viewModel.selectedPlace {
                                PlaceDetailView(place: place, isSaved: viewModel.isSaved(place)) {
                                    viewModel.toggleSave(place)
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSavedSelected.toggle()
                        
                        withAnimation {
                            viewModel.isShowingOnlySavedPlaces = isSavedSelected
                        }
                    }) {
                        Image(systemName: isSavedSelected ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                    }
                }
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task { await viewModel.loadPlaces() }
        }
    }
    
    func segmentedControl() -> some View {
        Picker("View", selection: $viewModel.selectedTab) {
            ForEach(PlacesViewModel.PlaceTab.allCases, id: \.self) { tab in
                Text(tab.rawValue).tag(tab)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
}
