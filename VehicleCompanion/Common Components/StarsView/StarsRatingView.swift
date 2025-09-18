//
//  StarsView.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import SwiftUI

struct StarsRatingView: View {
    var rating: Double
    
    var body: some View {
        HStack(spacing: 2.0) {
            ForEach(0..<5) { index in
                starView(for: index, rating: rating)
                    .foregroundStyle(.yellow)
            }
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

#Preview {
    StarsRatingView(rating: 2.6)
}
