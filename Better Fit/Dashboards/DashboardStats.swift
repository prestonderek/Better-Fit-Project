//
//  DashboardStats.swift
//  Better Fit
//
//  Created by Derek Preston on 2/1/26.
//

import Foundation

struct DashboardStats {
    static func latestWeightText(weights: [WeightEntry]) -> String {
        guard let w = weights.sorted(by: { $0.date > $1.date }).first else { return "—" }
        return String(format: "%.1f lbs", w.weightLbs)
    }

    static func todaysCaloriesText(meals: [MealEntry], calendar: Calendar = .current) -> String {
        let total = meals
            .filter { calendar.isDateInToday($0.date) }
            .reduce(0) { $0 + $1.calories }

        return total == 0 ? "—" : "\(total) kcal"
    }

    static func lastWorkoutText(workouts: [WorkoutEntry]) -> String {
        guard let w = workouts.sorted(by: { $0.date > $1.date }).first else { return "—" }
        let weight = String(format: "%.0f", w.weightLbs)
        return "\(w.exerciseName) (\(w.sets)x\(w.reps) @ \(weight))"
    }
}

