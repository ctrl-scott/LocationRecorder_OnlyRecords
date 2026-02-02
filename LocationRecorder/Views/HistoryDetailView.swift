//
//  HistoryDetailView.swift
//  LocationRecorder
//
//  Created by Scott Owen on 2/2/26.
//

import SwiftUI

struct HistoryDetailView: View {
    let record: LocationRecord

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(record.createdAt)
                    .font(.title3.weight(.bold))

                Group {
                    Text("Latitude: \(record.latitude)")
                    Text("Longitude: \(record.longitude)")
                    if let a = record.accuracyM {
                        Text("Accuracy (m): \(a)")
                    }
                }

                Divider()

                Text("Address")
                    .font(.headline)

                Text(record.addressLine ?? "Address unavailable")

                Spacer(minLength: 20)

                Text("This history is read-only. The app does not provide editing or deletion.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Record Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
