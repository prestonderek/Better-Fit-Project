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
    @EnvironmentObject var clientSession: ClientSession

    @Query private var plans: [ClientPlan]

    @State private var caloriesText = ""
    @State private var notes = ""
    @State private var errorMessage: String?
    @State private var showingClientPicker = false

    private var effectiveClient: ClientProfile {
        clientSession.activeClient ?? client
    }

    private var clientPlans: [ClientPlan] {
        plans.filter { $0.clientId == effectiveClient.id }
    }

    var body: some View {
        VStack(spacing: 8) {
            if clientSession.activeClient != nil {
                ActiveClientBanner(client: effectiveClient) {
                    showingClientPicker = true
                }
                .padding(.horizontal)
            }

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
                .alert("Oops", isPresented: .constant(errorMessage != nil)) {
                    Button("OK") { errorMessage = nil }
                } message: {
                    Text(errorMessage ?? "")
                }
                .onAppear { loadExistingPlan() }
            }
        }
        .sheet(isPresented: $showingClientPicker) {
            TrainerClientPickerView()
        }
    }

    private func loadExistingPlan() {
        if let existing = clientPlans.first {
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

            if let existing = clientPlans.first {
                existing.dailyCaloriesTarget = calories
                existing.notes = notes
                existing.updatedAt = .now
            } else {
                modelContext.insert(
                    ClientPlan(
                        clientId: effectiveClient.id,
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
