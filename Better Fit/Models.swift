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

