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

                List {
                    ForEach(entries) { e in
                        VStack(alignment: .leading) {
                            Text("\(e.weightLbs, specifier: "%.1f") lbs")
                                .font(.headline)
                            Text(e.date.formatted(date: .abbreviated, time: .omitted))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
            .navigationTitle("Weight Log")
        }
    }

    private func addEntry() {
        guard let w = Double(weightText) else { return }
        modelContext.insert(WeightEntry(date: .now, weightLbs: w))
        weightText = ""
    }

    private func delete(at offsets: IndexSet) {
        for i in offsets {
            modelContext.delete(entries[i])
        }
    }
}

