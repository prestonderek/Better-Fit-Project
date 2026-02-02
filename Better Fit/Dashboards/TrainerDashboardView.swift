//
//  TrainerDashboardView.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI

struct TrainerDashboardView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Trainer") {
                    Text("Clients (Sprint 2)")
                    Text("Assign Plans (Sprint 2)")
                }
            }
            .navigationTitle("Trainer Dashboard")
        }
    }
}

