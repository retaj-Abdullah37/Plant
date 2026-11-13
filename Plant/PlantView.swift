//
//  PlantView.swift
//  Plant
//
//  Created by Retaj Abdullah on 02/06/1448 AH.
//



import SwiftUI

private enum PlantSheet: Identifiable {
    case add
    case edit(PlantRecord)

    var id: String {
        switch self {
        case .add:
            return "add"
        case .edit(let plant):
            return plant.id.uuidString
        }
    }
}

struct PlantView: View {

    @StateObject private var viewModel: PlantViewModel
    @State private var activeSheet: PlantSheet?

    private let green = Color(
        red: 0.16,
        green: 0.48,
        blue: 0.40
    )

    private let sunColor = Color(
        red: 0.82,
        green: 0.74,
        blue: 0.42
    )

    private let waterColor = Color(
        red: 0.72,
        green: 0.85,
        blue: 0.92
    )

    init(previewMode: Bool = false) {
        _viewModel = StateObject(
            wrappedValue: PlantViewModel(
                useStorage: !previewMode
            )
        )
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            // Header
            Text("My Plants 🌱")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, 25)

            Divider()
                .background(Color.gray.opacity(0.5))
                .padding(.top, 20)

            if viewModel.plants.isEmpty {

                // Empty Screen
                Spacer()

                Text("No reminders set yet..")
                    .font(.system(size: 25, weight: .medium))
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity)

                Spacer()

            } else if viewModel.allCompleted {

                // All Reminders Completed
                allDoneContent

            } else {

                // Today's Progress
                VStack(spacing: 12) {

                    Text(viewModel.progressMessage)
                        .font(.system(size: 16))
                        .foregroundStyle(.white)

                    ProgressView(
                        value: Double(viewModel.completedCount),
                        total: Double(viewModel.plants.count)
                    )
                    .tint(green)
                    .animation(
                        .easeInOut(duration: 0.3),
                        value: viewModel.completedCount
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 28)
                .padding(.bottom, 20)

                // Plant List
                List {

                    ForEach(viewModel.plants) { plant in

                        plantRow(plant)
                            .listRowBackground(Color.black)
                            .listRowInsets(
                                EdgeInsets(
                                    top: 0,
                                    leading: 0,
                                    bottom: 0,
                                    trailing: 0
                                )
                            )
                            .swipeActions(edge: .trailing) {

                                Button(role: .destructive) {
                                    viewModel.delete(plant.id)
                                } label: {
                                    Label(
                                        "Delete",
                                        systemImage: "trash"
                                    )
                                }
                            }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }

            // Add Button
            HStack {

                Spacer()

                Button {
                    activeSheet = .add
                } label: {

                    Image(systemName: "plus")
                        .font(.system(size: 25, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                        .background(green)
                        .clipShape(Circle())
                }
                .accessibilityLabel("Add Plant Reminder")
            }
            .padding(.bottom, 30)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .sheet(item: $activeSheet) { destination in

            switch destination {

            case .add:
                PlantReminderFormView(
                    plant: nil,
                    onSave: viewModel.save
                )

            case .edit(let plant):
                PlantReminderFormView(
                    plant: plant,
                    onSave: viewModel.save,
                    onDelete: viewModel.delete
                )
            }
        }
    }

    // MARK: - Plant Row

    private func plantRow(_ plant: PlantRecord) -> some View {

        HStack(spacing: 15) {

            Button {
                viewModel.toggleCompleted(plant.id)
            } label: {

                Image(
                    systemName: plant.isCompletedToday
                    ? "checkmark.circle.fill"
                    : "circle"
                )
                .font(.system(size: 27))
                .foregroundStyle(
                    plant.isCompletedToday
                    ? Color.mint
                    : Color.gray
                )
            }
            .buttonStyle(.plain)

            Button {
                activeSheet = .edit(plant)
            } label: {

                VStack(alignment: .leading, spacing: 8) {

                    Label(
                        "in \(plant.room)",
                        systemImage: "location.north"
                    )
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)

                    Text(plant.name)
                        .font(.system(size: 22))
                        .foregroundStyle(
                            plant.isCompletedToday
                            ? Color.gray
                            : Color.white
                        )

                    HStack(spacing: 10) {

                        infoTag(
                            plant.light,
                            icon: "sun.max",
                            color: sunColor
                        )

                        infoTag(
                            plant.waterAmount,
                            icon: "drop",
                            color: waterColor
                        )
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 15)
    }

    // MARK: - Information Tags

    private func infoTag(
        _ text: String,
        icon: String,
        color: Color
    ) -> some View {

        HStack(spacing: 5) {

            Image(systemName: icon)

            Text(text)
        }
        .font(.system(size: 12))
        .foregroundStyle(color)
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background(
            Color.white.opacity(0.08),
            in: RoundedRectangle(cornerRadius: 8)
        )
    }

    // MARK: - All Done Screen

    private var allDoneContent: some View {

        VStack(spacing: 0) {

            Spacer()

            Image("plantDone")
                .resizable()
                .scaledToFit()
                .frame(width: 190, height: 190)
                .padding(12)
                .background(
                    Color.white.opacity(0.04),
                    in: Circle()
                )

            Text("All Done! 🎉")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, 30)

            Text("All Reminders Completed")
                .font(.system(size: 16))
                .foregroundStyle(.gray)
                .padding(.top, 12)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PlantView(previewMode: true)
}
