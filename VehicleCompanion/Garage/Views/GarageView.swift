//
//  GarageView.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import SwiftUI
import SwiftData

struct GarageView: View {
    @State private var viewModel: GarageViewModel
    
    init(viewModel: GarageViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.vehicles.isEmpty {
                    GarageEmptyView(message: viewModel.garageEmptyMessage)
                } else {
                    List {
                        ForEach(viewModel.vehicles) { vehicle in
                            VehicleRowView(vehicle: vehicle)
                                .onTapGesture {
                                    viewModel.updateWithVehicle(vehicle)
                                }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteVehicles(at: indexSet)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(viewModel.addButtonTitle) {
                        viewModel.isShowingAddSheet = true
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingAddSheet) {
                VehicleDetailsView(vehicle: $viewModel.vehicleDetailsViewModel.newVehicle,
                                   navigationTitle: viewModel.vehicleDetailsViewModel.navigationTitle,
                                   onSave: viewModel.onSave,
                                   onCancel: {
                    viewModel.isShowingAddSheet = false
                })
            }
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.onViewAppear()
            }
        }
    }
}
