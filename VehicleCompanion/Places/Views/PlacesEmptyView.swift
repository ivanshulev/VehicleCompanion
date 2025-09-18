//
//  PlacesEmptyView.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import SwiftUI

struct PlacesEmptyView: View {
    let message: String
    let refreshButtonTitle: String
    var onRefreshButtonTap: () -> Void
    
    var body: some View {
        VStack {
            Text(message)
            
            Button(refreshButtonTitle) {
                onRefreshButtonTap()
            }
        }
    }
}
