//
//  WorkoutLogView.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI
import SwiftData

struct WorkoutLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\WorkoutEntry.date, order: .reverse)])
    private var workouts: [WorkoutEntry]

    @State private var exerciseName: String = ""
    @State private var setsText: String = "3"
    @State private var repsText: String = "10"
    @State private var weightText: String = "0"

    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                VStack(spacing: 10) {
                    TextField("Exercise name (e.g., Bench Press)", text: $exerciseName)
                        .textFieldStyle(.roundedBorder)

                    HStack {
                        TextField("Sets", text: $setsText)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)

                        TextField("Reps", text: $repsText)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)

                        TextField("Weight (lbs)", text: $weightText)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                    }

                    Button("Add Workout") { addWorkout() }
                        .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)

                if workouts.isEmpty {
                    ContentUnavailableView(
                        "No workouts logged yet",
                        systemImage: "dumbbell",
                        description: Text("Add your first workout above.")
                    )
                } else {
                    List {
                        ForEach(workouts, id: \.id) { w in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(w.exerciseName)
                                    .font(.headline)

                                Text("\(w.sets) sets × \(w.reps) reps @ \(w.weightLbs, specifier: "%.1f") lbs")

                                Text(w.date.formatted(date: .abbreviated, time: .shortened))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .navigationTitle("Workout Log")
            .alert("Oops", isPresented: .constant(errorMessage != nil), actions: {
                Button("OK") { errorMessage = nil }
            }, message: {
                Text(errorMessage ?? "")
            })
        }
    }

    private func addWorkout() {
        do {
            let name = try Validators.nonEmpty(exerciseName, fieldName: "Exercise name", minChars: 2)
            let sets = try Validators.parsePositiveInt(setsText, fieldName: "Sets", max: 100)
            let reps = try Validators.parsePositiveInt(repsText, fieldName: "Reps", max: 1000)

            // Weight: allow 0 for bodyweight movements, but don't allow negative.
            let trimmed = weightText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let weight = Double(trimmed) else {
                throw ValidationError.message("Weight must be a number.")
            }
            guard weight >= 0 else {
                throw ValidationError.message("Weight cannot be negative.")
            }
            guard weight <= 5000 else {
                throw ValidationError.message("Weight must be ≤ 5000.")
            }

            modelContext.insert(
                WorkoutEntry(date: .now, exerciseName: name, sets: sets, reps: reps, weightLbs: weight)
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func delete(_ offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(workouts[index])
        }
    }
}

