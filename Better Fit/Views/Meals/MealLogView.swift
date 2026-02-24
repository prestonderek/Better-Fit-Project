//
//  MealLogView.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI
import SwiftData

struct MealLogView: View {
    let clientId: UUID

    @Environment(\.modelContext) private var modelContext
    @Query private var meals: [MealEntry]

    @State private var caloriesText = ""
    @State private var note = ""
    @State private var errorMessage: String?

    init(clientId: UUID) {
        self.clientId = clientId
        _meals = Query(
            filter: #Predicate<MealEntry> { $0.clientId == clientId },
            sort: [SortDescriptor(\MealEntry.date, order: .reverse)]
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                VStack(spacing: 10) {
                    TextField("Calories", text: $caloriesText)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)

                    TextField("Note (optional)", text: $note)
                        .textFieldStyle(.roundedBorder)

                    Button("Add Meal") { addMeal() }
                        .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)

                if meals.isEmpty {
                    ContentUnavailableView(
                        "No meals logged",
                        systemImage: "fork.knife",
                        description: Text("Add your first meal above.")
                    )
                } else {
                    List {
                        ForEach(meals, id: \.id) { m in
                            VStack(alignment: .leading) {
                                Text("\(m.calories) kcal")
                                    .font(.headline)
                                if !m.note.isEmpty {
                                    Text(m.note)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .navigationTitle("Meal Log")
            .alert("Oops", isPresented: .constant(errorMessage != nil)) {
                Button("OK") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    private func addMeal() {
        do {
            let cals = try Validators.parsePositiveInt(caloriesText, fieldName: "Calories", max: 20000)
            modelContext.insert(MealEntry(date: .now, calories: cals, note: note, clientId: clientId))
            caloriesText = ""
            note = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func delete(_ offsets: IndexSet) {
        offsets.forEach { modelContext.delete(meals[$0]) }
    }
}
