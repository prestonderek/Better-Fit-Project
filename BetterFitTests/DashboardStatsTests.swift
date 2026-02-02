//
//  DashboardStatsTests.swift
//  BetterFitTests
//
//  Created by Derek Preston on 2/1/26.
//

import XCTest
@testable import Better_Fit

final class DashboardStatsTests: XCTestCase {

    func testLatestWeightText_NoWeights_ReturnsDash() {
        let text = DashboardStats.latestWeightText(weights: [])
        XCTAssertEqual(text, "—")
    }

    func testLatestWeightText_PicksMostRecentByDate() {
        let older = WeightEntry(date: Date(timeIntervalSince1970: 100), weightLbs: 180.0)
        let newer = WeightEntry(date: Date(timeIntervalSince1970: 200), weightLbs: 185.5)

        let text = DashboardStats.latestWeightText(weights: [older, newer])
        XCTAssertEqual(text, "185.5 lbs")
    }

    func testTodaysCaloriesText_NoMealsToday_ReturnsDash() {
        let yesterday = MealEntry(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, calories: 700, note: "")
        let text = DashboardStats.todaysCaloriesText(meals: [yesterday])
        XCTAssertEqual(text, "—")
    }

    func testTodaysCaloriesText_SumsOnlyToday() {
        let today1 = MealEntry(date: Date(), calories: 500, note: "")
        let today2 = MealEntry(date: Date(), calories: 800, note: "")
        let yesterday = MealEntry(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, calories: 900, note: "")

        let text = DashboardStats.todaysCaloriesText(meals: [today1, today2, yesterday])
        XCTAssertEqual(text, "1300 kcal")
    }

    func testLastWorkoutText_NoWorkouts_ReturnsDash() {
        let text = DashboardStats.lastWorkoutText(workouts: [])
        XCTAssertEqual(text, "—")
    }
}

