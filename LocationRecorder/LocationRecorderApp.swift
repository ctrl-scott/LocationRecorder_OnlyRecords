//
//  LocationRecorderApp.swift
//  LocationRecorder
//
//  Created by Scott Owen on 2/2/26.
//

import SwiftUI

@main
struct LocationRecorderApp: App {
    private let services: AppServices

      init() {
          do {
              let db = try SQLiteDatabase()
              let store = LocationRecordStore(database: db)
              self.services = AppServices(store: store)
          } catch {
              fatalError("Database initialization failed: \(error.localizedDescription)")
          }
      }

      var body: some Scene {
          WindowGroup {
              MainMenuView()
                  .environmentObject(services)
          }
      }
  }
