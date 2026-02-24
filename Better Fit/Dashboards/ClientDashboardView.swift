//
//  ClientDashboardView.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI
import SwiftData

struct ClientDashboardView: View {
    @EnvironmentObject var clientSession: ClientSession

    @Query(sort: [SortDescriptor(\WeightEntry.date, order: .reverse)])
    private var weights: [WeightEntry]

    @Query(sort: [SortDescriptor(\MealEntry.date, order: .reverse)])
    private var meals: [MealEntry]

    @Query(sort: [SortDescriptor(\WorkoutEntry.date, order: .reverse)])
    private var workouts: [WorkoutEntry]

    var body: some View {
        Group {
            if let activeClient = clientSession.activeClient {
                dashboard(for: activeClient)
            } else {
                noClientSelectedView
            }
        }
    }

    // MARK: - Main Dashboard (safe, client-aware)

    private func dashboard(for client: ClientProfile) -> some View {
        NavigationStack {
            List {
                // MARK: Summary
                Section {
                    CardView {
                        SummaryRow(
                            title: "Latest Weight",
                            value: latestWeightText(for: client),
                            systemImage: "scalemass"
                        )
                    }
                    .listRowBackground(Color.clear)

                    CardView {
                        SummaryRow(
                            title: "Today's Calories",
                            value: todaysCaloriesText(for: client),
                            systemImage: "flame"
                        )
                    }
                    .listRowBackground(Color.clear)

                    CardView {
                        SummaryRow(
                            title: "Last Workout",
                            value: lastWorkoutText(for: client),
                            systemImage: "dumbbell"
                        )
                    }
                    .listRowBackground(Color.clear)
                } header: {
                    SectionHeaderView("Summary", systemImage: "chart.bar")
                }

                // MARK: Tracking
                Section {
                    NavigationLink("Weight Log") {
                        WeightLogView(clientId: client.id)
                    }

                    NavigationLink("Meals") {
                        MealLogView(clientId: client.id)
                    }

                    NavigationLink("Workouts") {
                        WorkoutLogView(clientId: client.id)
                    }
                } header: {
                    SectionHeaderView("Tracking", systemImage: "chart.bar")
                }
            }
            .navigationTitle("Client Dashboard")
        }
    }

    // MARK: - Empty State (no active client)

    private var noClientSelectedView: some View {
        ContentUnavailableView(
            "No Client Selected",
            systemImage: "person.crop.circle.badge.questionmark",
            description: Text("Select a client to view their dashboard.")
        )
    }

    // MARK: - Dashboard Stats (filtered by client)

    private func latestWeightText(for client: ClientProfile) -> String {
        let clientWeights = weights.filter { $0.clientId == client.id }
        return DashboardStats.latestWeightText(weights: clientWeights)
    }

    private func todaysCaloriesText(for client: ClientProfile) -> String {
        let clientMeals = meals.filter { $0.clientId == client.id }
        return DashboardStats.todaysCaloriesText(meals: clientMeals)
    }

    private func lastWorkoutText(for client: ClientProfile) -> String {
        let clientWorkouts = workouts.filter { $0.clientId == client.id }
        return DashboardStats.lastWorkoutText(workouts: clientWorkouts)
    }
}

// MARK: - Summary Row (unchanged)

private struct SummaryRow: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: systemImage)
                .foregroundStyle(Theme.Colors.primary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(title)
                    .font(Theme.Fonts.sectionHeader)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Brand.Accent.primary)
                    .monospacedDigit()
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(Brand.Accent.primary.opacity(0.15))
                    .frame(width: 36, height: 36)

                Image(systemName: systemImage)
                    .foregroundStyle(Brand.Accent.primary)
            }
        }
        .padding(.vertical, 4)
    }
}
