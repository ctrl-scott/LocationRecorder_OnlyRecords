//
//  HistoryListView.swift
//  LocationRecorder
//
//  Created by Scott Owen on 2/2/26.
//

import SwiftUI
import Combine
import Foundation

struct HistoryListView: View {

    @EnvironmentObject private var services: AppServices
    @State private var records: [LocationRecord] = []
    @State private var errorMessage: String?

    var body: some View {
        List {
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            ForEach(records) { r in
                NavigationLink {
                    HistoryDetailView(record: r)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(r.createdAt)
                            .font(.headline)

                        Text(r.addressLine ?? "Address unavailable")
                            .font(.subheadline)

                        Text("(\(r.latitude), \(r.longitude))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Location History")
        .onAppear {
            load()
        }
        .refreshable {
            load()
        }
    }

    private func load() {
        do {
            records = try services.store.fetchAll()
            errorMessage = nil
        } catch {
            records = []
            errorMessage = "Load failed: \(error.localizedDescription)"
        }
    }
}
