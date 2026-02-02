//
//  MealLogView.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI
import SwiftData

struct MealLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\MealEntry.date, order: .reverse)])
    private var meals: [MealEntry]

    @State private var caloriesText: String = ""
    @State private var note: String = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                VStack(spacing: 10) {
                    HStack {
                        TextField("Calories (e.g., 650)", text: $caloriesText)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)

                        Button("Add") { addMeal() }
                            .buttonStyle(.borderedProminent)
                    }

                    TextField("Note (optional) e.g., Chicken bowl", text: $note)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)

                if meals.isEmpty {
                    ContentUnavailableView(
                        "No meals logged yet",
                        systemImage: "fork.knife",
                        description: Text("Add your first meal above.")
                    )
                } else {
                    List {
                        ForEach(meals, id: \.id) { m in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(m.calories) kcal")
                                    .font(.headline)

                                if !m.note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    Text(m.note)
                                }

                                Text(m.date.formatted(date: .abbreviated, time: .shortened))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .navigationTitle("Meal Log")
            .alert("Oops", isPresented: .constant(errorMessage != nil), actions: {
                Button("OK") { errorMessage = nil }
            }, message: {
                Text(errorMessage ?? "")
            })
        }
    }

    private func addMeal() {
        do {
            let cals = try Validators.parsePositiveInt(caloriesText, fieldName: "Calories", max: 20000)

            // Keep note optional, but trim it
            let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)

            modelContext.insert(MealEntry(date: .now, calories: cals, note: trimmedNote))
            caloriesText = ""
            note = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func delete(_ offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(meals[index])
        }
    }
}


