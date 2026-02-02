//
//  ContentView.swift
//  LocationRecorder
//
//  Created by Scott Owen on 2/2/26.
//

import SwiftUI
import Combine
import Foundation

struct ContentView: View {

    @EnvironmentObject private var services: AppServices

    var body: some View {
        MainMenuView()
    }
}

#Preview {
    // Preview-safe dummy container
    let previewDB = try! SQLiteDatabase(filename: "preview.sqlite")
    let previewStore = LocationRecordStore(database: previewDB)
    let previewServices = AppServices(store: previewStore)

    ContentView()
        .environmentObject(previewServices)
}
