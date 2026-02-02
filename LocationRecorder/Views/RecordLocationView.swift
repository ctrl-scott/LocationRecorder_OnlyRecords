//
//  RecordLocationView.swift
//  LocationRecorder
//
//  Created by Scott Owen on 2/2/26.
//

import SwiftUI
import Combine
import CoreLocation

struct RecordLocationView: View {

    @EnvironmentObject private var services: AppServices
    @State private var statusMessage: String = ""
    @State private var isSaving: Bool = false
    @State private var lastGeocoded: ReverseGeocodeResult?

    var body: some View {
        VStack(spacing: 14) {
            Text("Record Location")
                .font(.title2.weight(.bold))
                .padding(.top, 12)

            Group {
                if !statusMessage.isEmpty {
                    Text(statusMessage)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                if let err = services.locationService.lastError {
                    Text("Error: \(err)")
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }
            }

            Button {
                services.locationService.requestWhenInUseAuthorization()
                services.locationService.requestOneLocationFix()
            } label: {
                Text("Capture Current Location")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)

            if let loc = services.locationService.lastLocation {
                LocationPreviewCard(location: loc, geocode: lastGeocoded)
                    .padding(.horizontal)

                Button {
                    Task { await saveLocation(loc) }
                } label: {
                    Text(isSaving ? "Saving..." : "Save To History")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .disabled(isSaving)
                .padding(.horizontal)
            }

            Spacer()
        }
        .onChange(of: services.locationService.lastLocation) { _, newValue in
            guard let loc = newValue else { return }
            Task {
                let geo = await services.geocodingService.reverseGeocode(loc)
                await MainActor.run {
                    self.lastGeocoded = geo
                }
            }
        }
    }

    private func saveLocation(_ loc: CLLocation) async {
        isSaving = true
        defer { isSaving = false }

        let iso = ISO8601DateFormatter().string(from: Date())
        let geo = await services.geocodingService.reverseGeocode(loc)

        do {
            try services.store.insertRecord(
                createdAt: iso,
                latitude: loc.coordinate.latitude,
                longitude: loc.coordinate.longitude,
                accuracyM: loc.horizontalAccuracy,
                addressLine: geo.addressLine,
                street: geo.street,
                city: geo.city,
                state: geo.state,
                postalCode: geo.postalCode,
                country: geo.country
            )
            statusMessage = "Saved location record at \(iso)."
            lastGeocoded = geo
        } catch {
            statusMessage = "Save failed: \(error.localizedDescription)"
        }
    }
}

struct LocationPreviewCard: View {
    let location: CLLocation
    let geocode: ReverseGeocodeResult?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Captured")
                .font(.headline)

            Text("Latitude: \(location.coordinate.latitude)")
            Text("Longitude: \(location.coordinate.longitude)")
            Text("Accuracy (m): \(location.horizontalAccuracy)")

            Divider()

            Text("Address")
                .font(.headline)

            Text(geocode?.addressLine ?? "Address not available yet.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
