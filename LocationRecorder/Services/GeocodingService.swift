//
//  GeocodingService.swift
//  LocationRecorder
//
//  Created by Scott Owen on 2/2/26.
//

import CoreLocation
import Foundation

struct ReverseGeocodeResult {
    let addressLine: String?
    let street: String?
    let city: String?
    let state: String?
    let postalCode: String?
    let country: String?
}

final class GeocodingService {

    private let geocoder = CLGeocoder()

    func reverseGeocode(_ location: CLLocation) async -> ReverseGeocodeResult {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            let pm = placemarks.first

            let streetNumber = pm?.subThoroughfare
            let streetName = pm?.thoroughfare
            let street = [streetNumber, streetName]
                .compactMap { $0 }
                .joined(separator: " ")

            let city = pm?.locality
            let state = pm?.administrativeArea
            let postal = pm?.postalCode
            let country = pm?.country

            let cityState = [city, state].compactMap { $0 }.joined(separator: ", ")

            let addressLineParts = [
                street.isEmpty ? nil : street,
                cityState.isEmpty ? nil : cityState,
                postal,
                country
            ].compactMap { $0 }.filter { !$0.isEmpty }

            let addressLine = addressLineParts.joined(separator: " ")

            return ReverseGeocodeResult(
                addressLine: addressLine.isEmpty ? nil : addressLine,
                street: street.isEmpty ? nil : street,
                city: city,
                state: state,
                postalCode: postal,
                country: country
            )
        } catch {
            return ReverseGeocodeResult(
                addressLine: nil,
                street: nil,
                city: nil,
                state: nil,
                postalCode: nil,
                country: nil
            )
        }
    }
}
