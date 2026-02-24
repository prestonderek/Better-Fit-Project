//
//  ClientDetailView.swift
//  Better Fit
//
//  Created by Derek Preston on 2/20/26.
//

import SwiftUI
import SwiftData

struct ClientDetailView: View {
    let client: ClientProfile

    @EnvironmentObject var clientSession: ClientSession
    @State private var showingClientPicker = false
    @State private var showingPlanEditor = false

    // MARK: Queries (unfiltered; we filter safely in-memory)

    @Query(sort: [SortDescriptor(\WeightEntry.date, order: .reverse)])
    private var weights: [WeightEntry]

    @Query(sort: [SortDescriptor(\MealEntry.date, order: .reverse)])
    private var meals: [MealEntry]

    @Query(sort: [SortDescriptor(\WorkoutEntry.date, order: .reverse)])
    private var workouts: [WorkoutEntry]

    @Query private var plans: [ClientPlan]

    // MARK: Effective Client

    private var effectiveClient: ClientProfile {
        clientSession.activeClient ?? client
    }

    // MARK: Filtered data

    private var clientWeights: [WeightEntry] {
        weights.filter { $0.clientId == effectiveClient.id }
    }

    private var clientMeals: [MealEntry] {
        meals.filter { $0.clientId == effectiveClient.id }
    }

    private var clientWorkouts: [WorkoutEntry] {
        workouts.filter { $0.clientId == effectiveClient.id }
    }

    private var clientPlans: [ClientPlan] {
        plans.filter { $0.clientId == effectiveClient.id }
    }

    var body: some View {
        VStack(spacing: 8) {
            // Active client banner (trainer only)
            if clientSession.activeClient != nil {
                ActiveClientBanner(client: effectiveClient) {
                    showingClientPicker = true
                }
                .padding(.horizontal)
            }

            List {

                // MARK: Aggregates
                Section {
                    CardView {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Workouts")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("\(TrainerAggregates.totalWorkouts(clientWorkouts))")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                            }

                            Spacer()

                            VStack(alignment: .leading) {
                                Text("Avg Daily Calories")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(
                                    TrainerAggregates
                                        .averageDailyCalories(meals: clientMeals)
                                        .map { "\($0) kcal" } ?? "—"
                                )
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                            }

                            Spacer()

                            VStack(alignment: .leading) {
                                Text("Weight Change")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(
                                    TrainerAggregates
                                        .weightChange(weights: clientWeights) ?? "—"
                                )
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                            }
                        }
                    }
                }
                .listRowBackground(Color.clear)

                // MARK: Plan
                Section("Plan") {
                    if let plan = clientPlans.first {
                        Text("Daily Calories: \(plan.dailyCaloriesTarget)")
                        if !plan.notes.isEmpty {
                            Text(plan.notes)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Text("No plan assigned")
                            .foregroundStyle(.secondary)
                    }
                }

                // MARK: Profile
                Section("Profile") {
                    Text(effectiveClient.name)
                    Text(effectiveClient.email)
                        .foregroundStyle(.secondary)
                }

                // MARK: Recent Weights
                Section("Recent Weight") {
                    if clientWeights.isEmpty {
                        Text("No weight entries")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(clientWeights.prefix(5)) { w in
                            HStack {
                                Text(String(format: "%.1f lbs", w.weightLbs))
                                Spacer()
                                Text(w.date.formatted(date: .abbreviated, time: .omitted))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                // MARK: Recent Meals
                Section("Recent Meals") {
                    if clientMeals.isEmpty {
                        Text("No meal entries")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(clientMeals.prefix(5)) { m in
                            VStack(alignment: .leading) {
                                Text("\(m.calories) kcal")
                                if !m.note.isEmpty {
                                    Text(m.note)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }

                // MARK: Recent Workouts
                Section("Recent Workouts") {
                    if clientWorkouts.isEmpty {
                        Text("No workouts logged")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(clientWorkouts.prefix(5)) { w in
                            VStack(alignment: .leading) {
                                Text(w.exerciseName)
                                Text("\(w.sets)x\(w.reps) @ \(w.weightLbs, specifier: "%.0f") lbs")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Client Details")
            .toolbar {
                Button("Edit Plan") {
                    showingPlanEditor = true
                }
            }
        }
        .sheet(isPresented: $showingPlanEditor) {
            ClientPlanEditorView(client: effectiveClient)
        }
        .sheet(isPresented: $showingClientPicker) {
            TrainerClientPickerView()
        }
    }
}
