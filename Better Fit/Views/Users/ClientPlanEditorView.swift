//
//  ClientPlanEditorView.swift
//  Better Fit
//
//  Created by Derek Preston on 2/20/26.
//

import SwiftUI
import SwiftData

struct ClientPlanEditorView: View {
    let client: ClientProfile

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query private var plans: [ClientPlan]

    @State private var caloriesText: String = ""
    @State private var notes: String = ""
    @State private var errorMessage: String?

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
        NavigationStack {
            Form {
                Section("Daily Targets") {
                    TextField("Calories (e.g., 2200)", text: $caloriesText)
                        .keyboardType(.numberPad)
                }

                Section("Notes / Goals") {
                    TextField("Notes (optional)", text: $notes)
                }

                Section {
                    Button("Save Plan") { savePlan() }
                        .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Client Plan")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .alert("Oops", isPresented: .constant(errorMessage != nil), actions: {
                Button("OK") { errorMessage = nil }
            }, message: {
                Text(errorMessage ?? "")
            })
            .onAppear { loadExistingPlan() }
        }
    }

    private func loadExistingPlan() {
        if let existing = plans.first {
            caloriesText = String(existing.dailyCaloriesTarget)
            notes = existing.notes
        }
    }

    private func savePlan() {
        do {
            let calories = try Validators.parsePositiveInt(
                caloriesText,
                fieldName: "Calories",
                max: 20000
            )

            if let existing = plans.first {
                existing.dailyCaloriesTarget = calories
                existing.notes = notes
                existing.updatedAt = .now
            } else {
                modelContext.insert(
                    ClientPlan(
                        clientId: client.id,
                        dailyCaloriesTarget: calories,
                        notes: notes
                    )
                )
            }
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
