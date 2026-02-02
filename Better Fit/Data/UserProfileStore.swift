//
//  UserProfileStore.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import Foundation
import SwiftUI
import Combine
import SwiftData

@MainActor
final class UserProfileStore: ObservableObject {
    @Published var profile: UserProfile?

    func loadOrCreateProfile(modelContext: ModelContext) {
        // If already loaded, do nothing
        if profile != nil { return }

        do {
            let descriptor = FetchDescriptor<UserProfile>()
            let results = try modelContext.fetch(descriptor)

            if let existing = results.first {
                profile = existing
            } else {
                let newProfile = UserProfile(name: "", email: "", role: .client)
                modelContext.insert(newProfile)
                profile = newProfile
            }
        } catch {
            print("Failed to fetch UserProfile: \(error)")
        }
    }
}

