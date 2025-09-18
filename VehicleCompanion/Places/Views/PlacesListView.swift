//
//  PlacesListView.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import SwiftUI

struct PlacesListView: View {
    var viewModel: PlacesViewModel
    
    var body: some View {
        List(viewModel.filteredPlaces) { place in
            PlaceRowView(place: place, isSaved: viewModel.isSaved(place)) {
                viewModel.selectedPlace = place
                viewModel.isShowingDetail = true
            } onSave: {
                viewModel.toggleSave(place)
            }
        }
        .listStyle(PlainListStyle())
        .id(UUID())
    }
}
