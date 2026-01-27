//
//  ClientDashboardView.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI

struct ClientDashboardView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Tracking") {
                    NavigationLink("Weight Log") { WeightLogView() }
                    NavigationLink("Meals") { MealLogView() }
                    NavigationLink("Workouts") { Text("Workouts (next)") }
                }
            }
            .navigationTitle("Client Dashboard")
        }
    }
}

