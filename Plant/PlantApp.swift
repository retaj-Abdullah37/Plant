//
//  PlantApp.swift
//  Plant
//
//  Created by Retaj Abdullah on 02/06/1448 AH.
//


import SwiftUI

@main
struct PlantApp: App {

    init() {
        _ = NotificationManager.shared
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
}

struct AppRootView: View {

    var previewMode = false

    @AppStorage("hasStartedMVVM") private var hasStarted = false
    @State private var previewStarted = false

    private var started: Bool {
        previewMode ? previewStarted : hasStarted
    }

    var body: some View {

        if started {

            PlantView(previewMode: previewMode)

        } else {

            WelcomeView {
                if previewMode {
                    previewStarted = true
                } else {
                    hasStarted = true
                }
            }
        }
    }
}
