//
//  SQLiteDatabase.swift
//  LocationRecorder
//
//  Created by Scott Owen on 2/2/26.
//

import Foundation
import SQLite3

final class SQLiteDatabase {

    private(set) var db: OpaquePointer?

    init(filename: String = "location_journal.sqlite") throws {
        let url = try FileManager.default
            .url(for: .documentDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
            .appendingPathComponent(filename)

        if sqlite3_open(url.path, &db) != SQLITE_OK {
            throw NSError(
                domain: "SQLiteDatabase",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to open database."]
            )
        }

        try createTablesIfNeeded()
    }

    deinit {
        sqlite3_close(db)
    }

    private func createTablesIfNeeded() throws {
        let sql = """
        CREATE TABLE IF NOT EXISTS location_records (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          created_at TEXT NOT NULL,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          accuracy_m REAL,
          address_line TEXT,
          street TEXT,
          city TEXT,
          state TEXT,
          postal_code TEXT,
          country TEXT
        );
        CREATE INDEX IF NOT EXISTS idx_location_records_created_at
        ON location_records(created_at);
        """

        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            throw NSError(
                domain: "SQLiteDatabase",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "Failed to create tables."]
            )
        }
    }
}
