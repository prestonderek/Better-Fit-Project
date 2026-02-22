//
//  Better_FitApp.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI
import SwiftData

@main
struct BetterFitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            UserProfile.self,
            WeightEntry.self,
            MealEntry.self,
            WorkoutEntry.self,
            ClientProfile.self,
            ClientPlan.self
        ])
    }
}

