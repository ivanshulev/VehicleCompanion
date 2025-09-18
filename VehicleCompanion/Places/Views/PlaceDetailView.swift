//
//  PlaceDetailView.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import SwiftUI
import MapKit

struct PlaceDetailView: View {
    let place: Place
    let isSaved: Bool
    let onSave: () -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: place.imageURL) { image in
                        image.resizable().aspectRatio(contentMode: .fill).frame(height: 200).clipShape(RoundedRectangle(cornerRadius: 8))
                    } placeholder: {
                        Rectangle().fill(.gray.opacity(0.3)).frame(height: 200)
                    }
                    
                    Text(place.name)
                        .font(.title)
                    Text(place.category)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        StarsRatingView(rating: place.rating ?? 0)
                        
                        Spacer()
                        
                        Button(action: {
                            onSave()
                        }) {
                            Image(systemName: isSaved ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .font(.system(size: 24))
                        }
                    }
                    
                    Map(initialPosition: .region(MKCoordinateRegion(center: place.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))) {
                        Marker(place.name, coordinate: place.coordinate)
                    }
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    if let url = place.websiteURL {
                        Button("Open in Browser") {
                            UIApplication.shared.open(url)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
            }
            .navigationTitle(place.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func starView(for index: Int, rating: Double) -> some View {
        let indexInDouble = Double(index)
        
        if rating >= indexInDouble + 1 {
            return Image(systemName: "star.fill")
        } else if rating >= indexInDouble + 0.5 {
            return Image(systemName: "star.lefthalf.fill")
        } else {
            return Image(systemName: "star")
        }
    }
}
