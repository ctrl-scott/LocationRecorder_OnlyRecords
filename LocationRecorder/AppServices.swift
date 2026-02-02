//
//  AppServices.swift
//  LocationRecorder
//
//  Created by Scott Owen on 2/2/26.
//

import SwiftUI
import Combine
import Foundation

final class AppServices: ObservableObject {

    let store: LocationRecordStore
    let locationService: LocationService
    let geocodingService: GeocodingService
    let printService: PrintService

    init(store: LocationRecordStore) {
        self.store = store
        self.locationService = LocationService()
        self.geocodingService = GeocodingService()
        self.printService = PrintService()
    }
}

