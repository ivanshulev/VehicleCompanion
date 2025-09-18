//
//  PlaceRowView.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import SwiftUI

struct PlaceRowView: View {
    let place: Place
    let isSaved: Bool
    let onTap: () -> Void
    let onSave: () -> Void
    
    var body: some View {
        HStack {
            AsyncImage(url: place.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                Image(systemName: "photo").frame(width: 60, height: 60).foregroundStyle(.gray)
            }
            
            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.headline)
                
                Text(place.category)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                StarsRatingView(rating: place.rating ?? 0)
            }
            
            Spacer()
            
            Button(action: {
                onSave()
            }) {
                Image(systemName: isSaved ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                    .font(.system(size: 24))
            }
            .contentShape(Rectangle())
            .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .gesture(
            TapGesture()
                .onEnded { _ in
                    onTap()
                },
            including: .all
        )
        .accessibilityElement(children: .combine)
    }
}
