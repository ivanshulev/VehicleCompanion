//
//  AppConfig.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 19.09.25.
//

import SwiftUI
import CoreLocation

class AppConfig {
    var defaultCenterCoordinate: CLLocationCoordinate2D
    
    init() {
        self.defaultCenterCoordinate = CLLocationCoordinate2D(latitude: 39.068586,
                                                              longitude: -84.514571)
    }
}

struct AppConfigKey: EnvironmentKey {
    static let defaultValue: AppConfig = AppConfig()
}

extension EnvironmentValues {
    var appConfig: AppConfig {
        get { self[AppConfigKey.self] }
        set { self[AppConfigKey.self] = newValue }
    }
}
