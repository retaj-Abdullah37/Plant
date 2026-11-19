<h1 align="center">My Plants 🌱</h1>

<p align="center">
  A simple iOS app to organize plant care, track watering progress, and receive watering reminders.
</p>

<p align="center">
  <img src="Screenshots/welcome.png" width="190" alt="Welcome screen" />
  &nbsp;&nbsp;
  <img src="Screenshots/plants.png" width="190" alt="Plant list" />
  &nbsp;&nbsp;
  <img src="Screenshots/progress.png" width="190" alt="Daily progress" />
</p>

## Overview

**My Plants** is a native iOS application built with **SwiftUI**. It helps users keep their plants' care information in one place, set watering reminders, mark plants as watered, and see their daily watering progress through a simple dark-mode interface.

Each plant record includes its **name, room, light level, watering frequency,** and **water amount**. Plant data is saved locally on the device.

## Features

- **Plant management** — Add, edit, and delete plant reminders.
- **Personalized plant details** — Choose a room, light level (Full sun, Partial sun, or Low light), watering days, and water amount.
- **Daily watering checklist** — Mark plants as watered or undo a checkmark; completion is tracked for the current calendar day.
- **Progress tracking** — See the number of completed plants and an animated progress bar.
- **All Done screen** — Display a celebration state when every saved plant has been marked as watered today.
- **Local watering notifications** — Schedule a one-time test reminder two minutes after saving a plant, alongside recurring reminders based on its selected watering interval.
- **Multiple ways to delete** — Remove a plant from its edit form or with a swipe action in the list.
- **On-device storage** — Keep plant records between app launches using `UserDefaults` and `Codable`.
- **Dark-mode design** — A clean SwiftUI interface with Liquid Glass-style controls.

## Screenshots

All screenshots below are cropped directly from the original UI image supplied for this project. No stock or generated application screens are used.


| Welcome | No Reminders | Set Reminder |
| :---: | :---: | :---: |
| <img src="Screenshots/welcome.png" width="180" alt="Welcome view" /> | <img src="Screenshots/empty.png" width="180" alt="No reminders view" /> | <img src="Screenshots/reminder.png" width="180" alt="Set reminder form" /> |

| My Plants | Daily Progress | All Done |
| :---: | :---: | :---: |
| <img src="Screenshots/plants.png" width="180" alt="Saved plants" /> | <img src="Screenshots/progress.png" width="180" alt="Watering progress" /> | <img src="Screenshots/completed.png" width="180" alt="All reminders completed" /> |

| Edit / Delete | Swipe to Delete | Notification |
| :---: | :---: | :---: |
| <img src="Screenshots/delete_reminder.png" width="180" alt="Delete reminder button" /> | <img src="Screenshots/swipe_delete.png" width="180" alt="Swipe to delete" /> | <img src="Screenshots/notification.png" width="180" alt="Local watering notification" /> |

## How Notifications Work

When a plant is saved, the notification manager schedules two local notification requests:

1. **Test reminder:** a one-time notification after **2 minutes**.
2. **Recurring reminder:** notifications at the selected interval, calculated from when the plant was saved.

| Watering option | Recurring interval |
| :--- | :--- |
| Every day | Every 1 day |
| Every 2 days | Every 2 days |
| Every 3 days | Every 3 days |
| Once a week | Every 7 days |
| Every 10 days | Every 10 days |
| Every 2 weeks | Every 14 days |

The notification includes the saved plant's name, for example: **“Hey! Let's water your Monstera 💦”**. Editing and saving a plant reschedules its notifications; deleting it cancels its scheduled notifications. Notifications can also be presented as a banner while the app is open.

> **Development note:** The first notification after 2 minutes is for testing. The recurring schedule starts from the time the plant is saved, **not** two minutes after the test reminder. The app must be allowed to send notifications in iOS Settings.

## Built With

| Technology | Purpose |
| :--- | :--- |
| **Swift** | App programming language |
| **SwiftUI** | Views, navigation, and interface components |
| **MVVM** | Separation of data, presentation, and state-management logic |
| **Combine** (`ObservableObject`, `@Published`) | Updates to plant state in the UI |
| **UserDefaults + Codable** | Local storage with JSON encoding and decoding |
| **UserNotifications** | Scheduling, displaying, and cancelling local alerts |

## Architecture & Key Files

The app follows the **Model–View–ViewModel (MVVM)** pattern.

```text
My Plants/
├── PlantRecord.swift             # Model: plant details and daily completion
├── PlantViewModel.swift          # Plant state, CRUD, progress, and persistence
├── WelcomeView.swift             # Welcome screen
├── PlantView.swift               # Empty list, plant list, progress, and All Done
├── PlantReminderFormView.swift   # Add, edit, and delete reminder form
├── NotificationManager.swift     # Local notification management
└── ContentView.swift             # Default Xcode starter view (if retained)
```

*The list above describes source files shared for this README; the actual Xcode folder layout and app entry-point file may differ.*

**`PlantRecord`** defines the data stored for each plant, including the last completion date. **`PlantViewModel`** loads and saves records with `UserDefaults`, manages additions and removals, tracks daily completion, and triggers notification scheduling or cancellation. The SwiftUI views display these states and allow users to interact with them.

## Requirements

- **Xcode 26 or later** with the iOS 26 SDK
- **iOS 26 or later** to support the SwiftUI `glassEffect` controls used in the interface
- A compatible iPhone or iOS simulator

## Getting Started

1. Clone or download the repository from GitHub.
2. Open the project's `.xcodeproj` file in Xcode (or `.xcworkspace`, if the repository uses one).
3. Select an iOS 26+ simulator or supported iPhone.
4. Press **Command + R** to build and run.
5. Grant notification permission when requested.
6. Add a plant, choose its watering options, and save it. The test notification should arrive approximately **2 minutes** later if notifications are permitted.

## Data & Privacy

Plant details are stored locally on the device using `UserDefaults`. The shared code does not use a remote backend or account sign-in for plant records.

## Author

**[YOUR NAME]**  
GitHub: **[retaj-Abdullah37](https://github.com)**

---

<p align="center">Made with 🌱 using SwiftUI.</p>
