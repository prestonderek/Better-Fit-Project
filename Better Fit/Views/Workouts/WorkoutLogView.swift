//
//  WorkoutLogView.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI
import SwiftData

struct WorkoutLogView: View {
    let clientId: UUID

    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [WorkoutEntry]

    @State private var exerciseName = ""
    @State private var setsText = "3"
    @State private var repsText = "10"
    @State private var weightText = "0"
    @State private var errorMessage: String?

    init(clientId: UUID) {
        self.clientId = clientId
        _workouts = Query(
            filter: #Predicate<WorkoutEntry> { $0.clientId == clientId },
            sort: [SortDescriptor(\WorkoutEntry.date, order: .reverse)]
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                VStack(spacing: 10) {
                    TextField("Exercise", text: $exerciseName)
                        .textFieldStyle(.roundedBorder)

                    HStack {
                        TextField("Sets", text: $setsText)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                        TextField("Reps", text: $repsText)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                        TextField("Weight", text: $weightText)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                    }

                    Button("Add Workout") { addWorkout() }
                        .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)

                if workouts.isEmpty {
                    ContentUnavailableView(
                        "No workouts logged",
                        systemImage: "dumbbell",
                        description: Text("Add your first workout above.")
                    )
                } else {
                    List {
                        ForEach(workouts, id: \.id) { w in
                            VStack(alignment: .leading) {
                                Text(w.exerciseName)
                                    .font(.headline)
                                Text("\(w.sets)x\(w.reps) @ \(w.weightLbs, specifier: "%.0f") lbs")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .navigationTitle("Workout Log")
            .alert("Oops", isPresented: .constant(errorMessage != nil)) {
                Button("OK") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    private func addWorkout() {
        do {
            let name = try Validators.nonEmpty(exerciseName, fieldName: "Exercise name", minChars: 2)
            let sets = try Validators.parsePositiveInt(setsText, fieldName: "Sets", max: 100)
            let reps = try Validators.parsePositiveInt(repsText, fieldName: "Reps", max: 1000)

            let weight = Double(weightText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            if weight < 0 { throw ValidationError.message("Weight cannot be negative.") }

            modelContext.insert(
                WorkoutEntry(
                    date: .now,
                    exerciseName: name,
                    sets: sets,
                    reps: reps,
                    weightLbs: weight,
                    clientId: clientId
                )
            )

            exerciseName = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func delete(_ offsets: IndexSet) {
        offsets.forEach { modelContext.delete(workouts[$0]) }
    }
}
