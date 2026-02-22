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
    
    @State private var showingPlanEditor = false

    // show ALL entries for now.
    // TODO:: these will be filtered by clientId.
    @Query(sort: [SortDescriptor(\WeightEntry.date, order: .reverse)])
    private var weights: [WeightEntry]

    @Query(sort: [SortDescriptor(\MealEntry.date, order: .reverse)])
    private var meals: [MealEntry]

    @Query(sort: [SortDescriptor(\WorkoutEntry.date, order: .reverse)])
    private var workouts: [WorkoutEntry]
    
    @Query private var plans: [ClientPlan]
    
    init(client: ClientProfile) {
        self.client = client

        let clientId = client.id
        _plans = Query(
            filter: #Predicate<ClientPlan> { plan in
                plan.clientId == clientId
            }
        )
    }

    var body: some View {
        List {
            Section("Plan") {
                if let plan = plans.first {
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
            
            Section("Profile") {
                Text(client.name)
                Text(client.email)
                    .foregroundStyle(.secondary)
            }

            Section("Recent Weight") {
                if weights.isEmpty {
                    Text("No weight entries")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(weights.prefix(5), id: \.id) { w in
                        HStack {
                            Text(String(format: "%.1f lbs", w.weightLbs))
                            Spacer()
                            Text(w.date.formatted(date: .abbreviated, time: .omitted))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Section("Recent Meals") {
                if meals.isEmpty {
                    Text("No meal entries")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(meals.prefix(5), id: \.id) { m in
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

            Section("Recent Workouts") {
                if workouts.isEmpty {
                    Text("No workouts logged")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(workouts.prefix(5), id: \.id) { w in
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
        .sheet(isPresented: $showingPlanEditor) {
            ClientPlanEditorView(client: client)
        }
    }
}
