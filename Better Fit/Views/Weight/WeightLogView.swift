//
//  WeightLogView.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI
import SwiftData

struct WeightLogView: View {
    let clientId: UUID

    @Environment(\.modelContext) private var modelContext

    @Query private var entries: [WeightEntry]   // no filter here

    @State private var weightText = ""
    @State private var errorMessage: String?

    init(clientId: UUID) {
        self.clientId = clientId
        _entries = Query(
            filter: #Predicate<WeightEntry> { $0.clientId == clientId },
            sort: [SortDescriptor(\WeightEntry.date, order: .reverse)]
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    TextField("Weight (lbs)", text: $weightText)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)

                    Button("Add") { addEntry() }
                        .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)

                if entries.isEmpty {
                    ContentUnavailableView(
                        "No weight entries",
                        systemImage: "scalemass",
                        description: Text("Add your first weigh-in above.")
                    )
                } else {
                    List {
                        ForEach(entries, id: \.id) { e in
                            VStack(alignment: .leading) {
                                Text(String(format: "%.1f lbs", e.weightLbs))
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
            .alert("Oops", isPresented: .constant(errorMessage != nil)) {
                Button("OK") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    private func addEntry() {
        do {
            let w = try Validators.parsePositiveDouble(weightText, fieldName: "Weight", max: 1200)
            modelContext.insert(WeightEntry(date: .now, weightLbs: w, clientId: clientId))
            weightText = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func delete(_ offsets: IndexSet) {
        offsets.forEach { modelContext.delete(entries[$0]) }
    }
}

