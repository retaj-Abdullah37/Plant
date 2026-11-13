//
//  PlantReminderFormView.swift
//  Plant
//
//  Created by Retaj Abdullah on 02/06/1448 AH.
//


import SwiftUI

struct PlantReminderFormView: View {
    @Environment(\.dismiss) private var dismiss

    let plant: PlantRecord?
    let onSave: (PlantRecord) -> Void
    var onDelete: ((UUID) -> Void)? = nil

    @State private var plantName: String
    @State private var room: String
    @State private var light: String
    @State private var days: String
    @State private var water: String

    private let panel = Color(
        red: 0.17,
        green: 0.17,
        blue: 0.18
    )

    private let green = Color(
        red: 0.16,
        green: 0.48,
        blue: 0.40
    )

    init(
        plant: PlantRecord? = nil,
        onSave: @escaping (PlantRecord) -> Void,
        onDelete: ((UUID) -> Void)? = nil
    ) {
        self.plant = plant
        self.onSave = onSave
        self.onDelete = onDelete

        _plantName = State(
            initialValue: plant?.name ?? ""
        )
        _room = State(
            initialValue: plant?.room ?? "Bedroom"
        )
        _light = State(
            initialValue: plant?.light ?? "Full Sun"
        )
        _days = State(
            initialValue: plant?.wateringDays ?? "Every day"
        )
        _water = State(
            initialValue: plant?.waterAmount ?? "20-50 ml"
        )
    }

    private var trimmedName: String {
        plantName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }

    var body: some View {
        VStack(spacing: 0) {

            // Header
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            Color.gray.opacity(0.25)
                        )
                        .clipShape(Circle())
                }

                Spacer()

                Text("Set Reminder")
                    .font(
                        .system(
                            size: 18,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.white)

                Spacer()

                Button {
                    saveReminder()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(green)
                        .clipShape(Circle())
                }
                .disabled(trimmedName.isEmpty)
                .opacity(
                    trimmedName.isEmpty ? 0.5 : 1
                )
            }
            .padding(.top, 25)

            ScrollView {
                VStack(spacing: 30) {

                    // Plant Name
                    HStack(spacing: 8) {
                        Text("Plant Name")
                            .foregroundStyle(.white)

                        TextField(
                            "Pothos",
                            text: $plantName
                        )
                        .foregroundStyle(.white)
                        .tint(.mint)
                    }
                    .padding(.horizontal, 18)
                    .frame(height: 60)
                    .background(
                        panel,
                        in: RoundedRectangle(
                            cornerRadius: 22
                        )
                    )

                    // Room and Light
                    VStack(spacing: 0) {
                        pickerRow(
                            "Room",
                            icon: "location",
                            selection: $room,
                            options: [
                                "Bedroom",
                                "Living Room",
                                "Kitchen",
                                "Balcony",
                                "Bathroom"
                            ]
                        )

                        Divider()
                            .padding(.horizontal, 15)

                        pickerRow(
                            "Light",
                            icon: "sun.max",
                            selection: $light,
                            options: [
                                "Full Sun",
                                "Partial Sun",
                                "Low Light"
                            ]
                        )
                    }
                    .background(
                        panel,
                        in: RoundedRectangle(
                            cornerRadius: 22
                        )
                    )

                    // Watering Days and Water
                    VStack(spacing: 0) {
                        pickerRow(
                            "Watering Days",
                            icon: "calendar",
                            selection: $days,
                            options: [
                                "Every day",
                                "Every 2 days",
                                "Every 3 days",
                                "Once a week",
                                "Every 10 days",
                                "Every 2 weeks"
                            ]
                        )

                        Divider()
                            .padding(.horizontal, 15)

                        pickerRow(
                            "Water",
                            icon: "drop",
                            selection: $water,
                            options: [
                                "20-50 ml",
                                "50-100 ml",
                                "100-200 ml",
                                "200-300 ml"
                            ]
                        )
                    }
                    .background(
                        panel,
                        in: RoundedRectangle(
                            cornerRadius: 22
                        )
                    )

                    // Delete Button
                    if let plant {
                        Button(role: .destructive) {
                            onDelete?(plant.id)
                            dismiss()
                        } label: {
                            Text("Delete Reminder")
                                .frame(maxWidth: .infinity)
                                .frame(height: 55)
                                .background(
                                    panel,
                                    in: Capsule()
                                )
                        }
                        .foregroundStyle(.red)
                    }
                }
                .padding(.top, 55)
                .padding(.bottom, 30)
            }
        }
        .padding(.horizontal, 20)
        .background(
            Color(
                red: 0.11,
                green: 0.11,
                blue: 0.12
            )
            .ignoresSafeArea()
        )
        .preferredColorScheme(.dark)
    }

    // Picker Row
    private func pickerRow(
        _ title: String,
        icon: String,
        selection: Binding<String>,
        options: [String]
    ) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundStyle(.white)

            Text(title)
                .foregroundStyle(.white)

            Spacer()

            Picker(title, selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .tint(.gray)
        }
        .padding(.horizontal, 16)
        .frame(height: 55)
    }

    // Save Reminder
    private func saveReminder() {
        guard !trimmedName.isEmpty else {
            return
        }

        var updated = plant ?? PlantRecord(
            name: trimmedName,
            room: room,
            light: light,
            wateringDays: days,
            waterAmount: water
        )

        updated.name = trimmedName
        updated.room = room
        updated.light = light
        updated.wateringDays = days
        updated.waterAmount = water

        onSave(updated)
        dismiss()
    }
}

#Preview("Set Reminder") {
    PlantReminderFormView(
        plant: nil,
        onSave: { _ in }
    )
}
