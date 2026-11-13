//
//  PlantRecord.swift
//  Plant
//
//  Created by Retaj Abdullah on 02/06/1448 AH.
//


import Foundation

struct PlantRecord: Identifiable, Codable {
    var id = UUID()
    var name: String
    var room: String
    var light: String
    var wateringDays: String
    var waterAmount: String
    var completedOn: Date? = nil

    var isCompletedToday: Bool {
        guard let completedOn else { return false }
        return Calendar.current.isDateInToday(completedOn)
    }
}
