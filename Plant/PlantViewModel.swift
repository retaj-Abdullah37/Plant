//
//  PlantViewModel.swift
//  Plant
//
//  Created by Retaj Abdullah on 02/06/1448 AH.
//


import Foundation
import Combine

final class PlantViewModel: ObservableObject {

    @Published private(set) var plants: [PlantRecord] = []

    private let storageKey = "myPlantsMVVM_v1"
    private let useStorage: Bool

    init(useStorage: Bool = true) {
        self.useStorage = useStorage

        if useStorage {
            loadPlants()
        }
    }

    var completedCount: Int {
        plants.filter { $0.isCompletedToday }.count
    }

    var allCompleted: Bool {
        !plants.isEmpty && completedCount == plants.count
    }

    var progressMessage: String {

        if allCompleted {
            return "All Done! 🎉"
        }

        if completedCount == 0 {
            return "Your plants are waiting for a sip 💦"
        }

        return "\(completedCount) of your plants feel loved today ✨"
    }

    // Save Plant
    func save(_ plant: PlantRecord) {

        if let index = plants.firstIndex(
            where: { $0.id == plant.id }
        ) {
            plants[index] = plant
        } else {
            plants.append(plant)
        }

        persistPlants()

        // Schedule watering notification
        if useStorage {
            NotificationManager.shared.scheduleReminder(
                for: plant.id
            )
        }
    }

    // Delete Plant
    func delete(_ id: UUID) {

        plants.removeAll { $0.id == id }

        persistPlants()

        if useStorage {
            NotificationManager.shared.cancelReminder(
                for: id
            )
        }
    }

    // Check / Uncheck
    func toggleCompleted(_ id: UUID) {

        guard let index = plants.firstIndex(
            where: { $0.id == id }
        ) else {
            return
        }

        plants[index].completedOn =
            plants[index].isCompletedToday ? nil : Date()

        persistPlants()
    }

    // Store Data
    private func persistPlants() {

        guard useStorage,
              let data = try? JSONEncoder().encode(plants)
        else {
            return
        }

        UserDefaults.standard.set(
            data,
            forKey: storageKey
        )
    }

    // Load Data
    private func loadPlants() {

        guard let data = UserDefaults.standard.data(
            forKey: storageKey
        ),
        let saved = try? JSONDecoder().decode(
            [PlantRecord].self,
            from: data
        ) else {
            return
        }

        plants = saved
    }
}
