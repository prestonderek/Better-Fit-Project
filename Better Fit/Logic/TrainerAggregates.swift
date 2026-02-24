//
//  TrainerAggregates.swift
//  Better Fit
//
//  Created by Derek Preston on 2/22/26.
//

import Foundation

struct TrainerAggregates {

    static func totalWorkouts(_ workouts: [WorkoutEntry]) -> Int {
        workouts.count
    }

    static func averageDailyCalories(meals: [MealEntry], calendar: Calendar = .current) -> Int? {
        let grouped = Dictionary(grouping: meals) {
            calendar.startOfDay(for: $0.date)
        }

        guard !grouped.isEmpty else { return nil }

        let dailyTotals = grouped.values.map { dayMeals in
            dayMeals.reduce(0) { $0 + $1.calories }
        }

        let average = dailyTotals.reduce(0, +) / dailyTotals.count
        return average
    }

    static func weightChange(weights: [WeightEntry]) -> String? {
        let sorted = weights.sorted { $0.date < $1.date }
        guard let first = sorted.first,
              let last = sorted.last,
              sorted.count >= 2 else { return nil }

        let diff = last.weightLbs - first.weightLbs
        let sign = diff >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", diff)) lbs"
    }
}
