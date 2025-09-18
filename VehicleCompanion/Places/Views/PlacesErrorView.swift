//
//  PlacesErrorView.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import SwiftUI

struct PlacesErrorView: View {
    let message: String
    let retryButtonTitle: String
    var onRetryButtonTap: () -> Void
    
    var body: some View {
        VStack {
            Text(message)
                .foregroundStyle(.red)
            Button(retryButtonTitle) {
                onRetryButtonTap()
            }
        }
    }
}
