//
//  LocationRecordStore.swift
//  LocationRecorder
//
//  Created by Scott Owen on 2/2/26.
//

import Foundation
import SQLite3

final class LocationRecordStore {

    private let database: SQLiteDatabase

    init(database: SQLiteDatabase) {
        self.database = database
    }

    func insertRecord(
        createdAt: String,
        latitude: Double,
        longitude: Double,
        accuracyM: Double?,
        addressLine: String?,
        street: String?,
        city: String?,
        state: String?,
        postalCode: String?,
        country: String?
    ) throws {

        let sql = """
        INSERT INTO location_records
        (created_at, latitude, longitude, accuracy_m, address_line, street, city, state, postal_code, country)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """

        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(database.db, sql, -1, &stmt, nil) == SQLITE_OK else {
            throw NSError(domain: "LocationRecordStore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to prepare insert statement."])
        }
        defer { sqlite3_finalize(stmt) }

        sqlite3_bind_text(stmt, 1, (createdAt as NSString).utf8String, -1, nil)
        sqlite3_bind_double(stmt, 2, latitude)
        sqlite3_bind_double(stmt, 3, longitude)

        if let accuracyM = accuracyM {
            sqlite3_bind_double(stmt, 4, accuracyM)
        } else {
            sqlite3_bind_null(stmt, 4)
        }

        bindOptionalText(stmt, index: 5, value: addressLine)
        bindOptionalText(stmt, index: 6, value: street)
        bindOptionalText(stmt, index: 7, value: city)
        bindOptionalText(stmt, index: 8, value: state)
        bindOptionalText(stmt, index: 9, value: postalCode)
        bindOptionalText(stmt, index: 10, value: country)

        guard sqlite3_step(stmt) == SQLITE_DONE else {
            throw NSError(domain: "LocationRecordStore", code: 2, userInfo: [NSLocalizedDescriptionKey: "Insert failed."])
        }
    }

    func fetchAll() throws -> [LocationRecord] {
        let sql = """
        SELECT id, created_at, latitude, longitude, accuracy_m, address_line, street, city, state, postal_code, country
        FROM location_records
        ORDER BY created_at DESC;
        """

        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(database.db, sql, -1, &stmt, nil) == SQLITE_OK else {
            throw NSError(domain: "LocationRecordStore", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to prepare fetch statement."])
        }
        defer { sqlite3_finalize(stmt) }

        var results: [LocationRecord] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            let record = LocationRecord(
                id: sqlite3_column_int64(stmt, 0),
                createdAt: readText(stmt, col: 1) ?? "",
                latitude: sqlite3_column_double(stmt, 2),
                longitude: sqlite3_column_double(stmt, 3),
                accuracyM: readDoubleOptional(stmt, col: 4),
                addressLine: readText(stmt, col: 5),
                street: readText(stmt, col: 6),
                city: readText(stmt, col: 7),
                state: readText(stmt, col: 8),
                postalCode: readText(stmt, col: 9),
                country: readText(stmt, col: 10)
            )
            results.append(record)
        }

        return results
    }

    private func bindOptionalText(_ stmt: OpaquePointer?, index: Int32, value: String?) {
        if let value = value {
            sqlite3_bind_text(stmt, index, (value as NSString).utf8String, -1, nil)
        } else {
            sqlite3_bind_null(stmt, index)
        }
    }

    private func readText(_ stmt: OpaquePointer?, col: Int32) -> String? {
        guard let cStr = sqlite3_column_text(stmt, col) else { return nil }
        return String(cString: cStr)
    }

    private func readDoubleOptional(_ stmt: OpaquePointer?, col: Int32) -> Double? {
        if sqlite3_column_type(stmt, col) == SQLITE_NULL { return nil }
        return sqlite3_column_double(stmt, col)
    }
}
