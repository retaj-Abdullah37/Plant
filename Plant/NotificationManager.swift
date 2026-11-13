//
//  NotificationManager.swift
//  Plant
//
//  Created by Retaj Abdullah on 02/06/1448 AH.
//


import Foundation
import UserNotifications

final class NotificationManager: NSObject,
    UNUserNotificationCenterDelegate, @unchecked Sendable {

    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()

    private override init() {
        super.init()
        center.delegate = self
    }

    // Schedule notification after 5 minutes
    func scheduleReminder(for plantID: UUID) {

        Task {
            do {
                let allowed = try await center.requestAuthorization(
                    options: [.alert, .sound]
                )

                guard allowed else { return }

                // Notification Content
                let content = UNMutableNotificationContent()

                content.body = "Hey! let's water your plant"
                content.sound = .default

                // 5 Minutes = 300 Seconds
                let trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: 300,
                    repeats: false
                )

                let request = UNNotificationRequest(
                    identifier: notificationID(for: plantID),
                    content: content,
                    trigger: trigger
                )

                try await center.add(request)

            } catch {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }

    // Cancel notification when plant is deleted
    func cancelReminder(for plantID: UUID) {

        let id = notificationID(for: plantID)

        center.removePendingNotificationRequests(
            withIdentifiers: [id]
        )

        center.removeDeliveredNotifications(
            withIdentifiers: [id]
        )
    }

    private func notificationID(for plantID: UUID) -> String {
        "watering-\(plantID.uuidString)"
    }

    // Show notification while app is open
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound])
    }
}
