//
//  Models.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var name: String
    var email: String
    var roleRaw: String

    init(name: String = "", email: String = "", role: AppRole = .client) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.roleRaw = role.rawValue
    }

    var role: AppRole {
        get { AppRole(rawValue: roleRaw) ?? .client }
        set { roleRaw = newValue.rawValue }
    }
}

@Model
final class WeightEntry {
    var id: UUID
    var date: Date
    var weightLbs: Double

    init(date: Date = .now, weightLbs: Double) {
        self.id = UUID()
        self.date = date
        self.weightLbs = weightLbs
    }
}

@Model
final class MealEntry {
    var id: UUID
    var date: Date
    var calories: Int
    var note: String

    init(date: Date = .now, calories: Int, note: String = "") {
        self.id = UUID()
        self.date = date
        self.calories = calories
        self.note = note
    }
}

@Model
final class WorkoutEntry {
    var id: UUID
    var date: Date
    var exerciseName: String
    var sets: Int
    var reps: Int
    var weightLbs: Double
    
    init(date: Date = .now, exerciseName: String, sets: Int, reps: Int, weightLbs: Double)
    {
        self.id = UUID()
        self.date = date
        self.exerciseName = exerciseName
        self.sets = sets
        self.reps = reps
        self.weightLbs = weightLbs
    }
}

@Model
final class ClientProfile {
    var id: UUID
    var name: String
    var email: String
    var createdAt: Date

    init(name: String, email: String) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.createdAt = .now
    }
}

@Model
final class ClientPlan {
    var id: UUID
    var clientId: UUID
    var dailyCaloriesTarget: Int
    var notes: String
    var updatedAt: Date

    init(clientId: UUID, dailyCaloriesTarget: Int, notes: String = "") {
        self.id = UUID()
        self.clientId = clientId
        self.dailyCaloriesTarget = dailyCaloriesTarget
        self.notes = notes
        self.updatedAt = .now
    }
}
