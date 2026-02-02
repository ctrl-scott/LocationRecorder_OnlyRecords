//
//  PrintHistoryView.swift
//  LocationRecorder
//
//  Created by Scott Owen on 2/2/26.
//

import SwiftUI

struct PrintHistoryView: View {

    @EnvironmentObject private var services: AppServices
    @State private var previewText: String = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 12) {
            Text("Print Location History")
                .font(.title2.weight(.bold))
                .padding(.top, 12)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            ScrollView {
                Text(previewText.isEmpty ? "No preview loaded." : previewText)
                    .font(.system(.footnote, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)

            HStack(spacing: 12) {
                Button("Load Preview") {
                    loadPreview()
                }
                .buttonStyle(.bordered)

                Button("Print") {
                    if !previewText.isEmpty {
                        services.printService.printText(previewText)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(previewText.isEmpty)
            }
            .padding(.bottom, 12)

            Spacer()
        }
        .padding(.horizontal, 12)
        .onAppear {
            loadPreview()
        }
    }

    private func loadPreview() {
        do {
            let records = try services.store.fetchAll()
            errorMessage = nil
            previewText = buildReport(records)
        } catch {
            errorMessage = "Load failed: \(error.localizedDescription)"
            previewText = ""
        }
    }

    private func buildReport(_ records: [LocationRecord]) -> String {
        var lines: [String] = []
        lines.append("Location History Report")
        lines.append("Generated: \(ISO8601DateFormatter().string(from: Date()))")
        lines.append("Total Records: \(records.count)")
        lines.append(String(repeating: "-", count: 50))

        for r in records {
            lines.append("Time: \(r.createdAt)")
            lines.append("Lat/Lon: \(r.latitude), \(r.longitude)")
            if let a = r.accuracyM {
                lines.append("Accuracy(m): \(a)")
            }
            lines.append("Address: \(r.addressLine ?? "Address unavailable")")
            lines.append(String(repeating: "-", count: 50))
        }

        return lines.joined(separator: "\n")
    }
}
