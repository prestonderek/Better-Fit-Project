//
//  WeightLogView.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI
import SwiftData

struct WeightLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WeightEntry.date, order: .reverse) private var entries: [WeightEntry]

    @State private var weightText: String = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    TextField("Weight (lbs)", text: $weightText)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)

                    Button("Add") {
                        addEntry()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(Double(weightText) == nil)
                }
                .padding(.horizontal)

                if entries.isEmpty {
                    ContentUnavailableView("No weight entries yet", systemImage: "scalemass", description: Text("Add your first weigh-in above."))
                } else {
                    List {
                        ForEach(entries, id: \.id) { e in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(e.weightLbs, specifier: "%.1f") lbs")
                                    .font(.headline)
                                Text(e.date.formatted(date: .abbreviated, time: .omitted))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }

            }
            .navigationTitle("Weight Log")
            .alert("Uh Oh!", isPresented: .constant(errorMessage != nil), actions: { Button("OK") {errorMessage = nil }}, message: { Text(errorMessage ?? "")})
        }
    }

    private func addEntry() {
        do {
            let w = try Validators.parsePositiveDouble(weightText, fieldName: "Weight", max: 1200)
            modelContext.insert(WeightEntry(date: .now, weightLbs: w))
            weightText = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }


    private func delete(at offsets: IndexSet) {
        for i in offsets {
            modelContext.delete(entries[i])
        }
    }
}

