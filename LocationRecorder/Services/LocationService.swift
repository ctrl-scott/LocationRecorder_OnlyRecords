//
//  LocationService.swift
//  LocationRecorder
//
//  Created by Scott Owen on 2/2/26.
//

import SwiftUI
import Combine
import CoreLocation
import Foundation

final class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()

    @Published var lastLocation: CLLocation?
    @Published var lastError: String?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestWhenInUseAuthorization() {
        lastError = nil
        manager.requestWhenInUseAuthorization()
    }

    func requestOneLocationFix() {
        lastError = nil
        manager.requestLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        DispatchQueue.main.async {
            self.lastLocation = loc
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.lastError = error.localizedDescription
        }
    }
}
