//
//  Better_FitApp.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct BetterFitApp: App {

    @StateObject private var authService = AuthService()
    @StateObject private var clientSession = ClientSession()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AuthGateView()
                .environmentObject(authService)
                .environmentObject(clientSession)
        }
        .modelContainer(for: [
            ClientProfile.self,
            ClientPlan.self,
            WeightEntry.self,
            MealEntry.self,
            WorkoutEntry.self,
            UserProfile.self
        ])
    }
}

