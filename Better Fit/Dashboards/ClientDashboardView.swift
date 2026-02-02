//
//  ClientDashboardView.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI
import SwiftData

struct ClientDashboardView: View {
    @Query(sort: [SortDescriptor(\WeightEntry.date, order: .reverse)])
    private var weights: [WeightEntry]

    @Query(sort: [SortDescriptor(\MealEntry.date, order: .reverse)])
    private var meals: [MealEntry]

    @Query(sort: [SortDescriptor(\WorkoutEntry.date, order: .reverse)])
    private var workouts: [WorkoutEntry]

    var body: some View {
        NavigationStack {
            List {
                Section("Summary") {
                    SummaryRow(
                        title: "Latest Weight",
                        value: latestWeightText,
                        systemImage: "scalemass"
                    )

                    SummaryRow(
                        title: "Today's Calories",
                        value: todaysCaloriesText,
                        systemImage: "flame"
                    )

                    SummaryRow(
                        title: "Last Workout",
                        value: lastWorkoutText,
                        systemImage: "dumbbell"
                    )
                }

                Section("Tracking") {
                    NavigationLink("Weight Log") { WeightLogView() }
                    NavigationLink("Meals") { MealLogView() }
                    NavigationLink("Workouts") { WorkoutLogView() }
                }
            }
            .navigationTitle("Client Dashboard")
        }
    }

    private var latestWeightText: String {
        DashboardStats.latestWeightText(weights: weights)
    }

    private var todaysCaloriesText: String {
        DashboardStats.todaysCaloriesText(meals: meals)
    }

    private var lastWorkoutText: String {
        DashboardStats.lastWorkoutText(workouts: workouts)
    }

}

private struct SummaryRow: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.headline)
            }
        }
        .padding(.vertical, 4)
    }
}
