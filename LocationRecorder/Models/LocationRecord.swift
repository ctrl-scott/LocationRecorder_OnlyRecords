//
//  LocationRecord.swift
//  LocationRecorder
//
//  Created by Scott Owen on 2/2/26.
//

import Foundation

struct LocationRecord: Identifiable {
    let id: Int64
    let createdAt: String
    let latitude: Double
    let longitude: Double
    let accuracyM: Double?

    let addressLine: String?
    let street: String?
    let city: String?
    let state: String?
    let postalCode: String?
    let country: String?
}
