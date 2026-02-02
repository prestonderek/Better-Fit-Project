//
//  ValidationHelpers.swift
//  Better Fit
//
//  Created by Derek Preston on 2/1/26.
//

import Foundation

enum ValidationError: LocalizedError {
    case message(String)

    var errorDescription: String? {
        switch self {
        case .message(let msg): return msg
        }
    }
}

struct Validators {
    static func parsePositiveDouble(_ text: String, fieldName: String, max: Double? = nil) throws -> Double {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value = Double(trimmed) else {
            throw ValidationError.message("\(fieldName) must be a number.")
        }
        guard value > 0 else {
            throw ValidationError.message("\(fieldName) must be greater than 0.")
        }
        if let max, value > max {
            throw ValidationError.message("\(fieldName) must be ≤ \(max).")
        }
        return value
    }

    static func parsePositiveInt(_ text: String, fieldName: String, max: Int? = nil) throws -> Int {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value = Int(trimmed) else {
            throw ValidationError.message("\(fieldName) must be a whole number.")
        }
        guard value > 0 else {
            throw ValidationError.message("\(fieldName) must be greater than 0.")
        }
        if let max, value > max {
            throw ValidationError.message("\(fieldName) must be ≤ \(max).")
        }
        return value
    }

    static func nonEmpty(_ text: String, fieldName: String, minChars: Int = 1) throws -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= minChars else {
            throw ValidationError.message("\(fieldName) can’t be empty.")
        }
        return trimmed
    }
}
