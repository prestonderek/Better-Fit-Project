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
                            .disabled(Int(caloriesText.trimmingCharacters(in: .whitespacesAndNewlines)) == nil)
                    }

                    TextField("Note (optional) e.g., Chicken bowl", text: $note)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)

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
            .navigationTitle("Meal Log")
        }
    }

    private func addMeal() {
        let trimmed = caloriesText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let cals = Int(trimmed) else { return }

        modelContext.insert(MealEntry(date: .now, calories: cals, note: note))
        caloriesText = ""
        note = ""
    }

    private func delete(_ offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(meals[index])
        }
    }
}

