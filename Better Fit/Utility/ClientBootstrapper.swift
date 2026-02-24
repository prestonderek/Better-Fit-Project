//
//  ClientBootstrapper.swift
//  Better Fit
//
//  Created by Derek Preston on 2/22/26.
//

import SwiftData
import Foundation

struct ClientBootstrapper {

    static func ensureClientProfile(
        userProfile: UserProfile,
        modelContext: ModelContext
    ) -> ClientProfile {

        let name = userProfile.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = userProfile.email.trimmingCharacters(in: .whitespacesAndNewlines)

        precondition(!name.isEmpty && !email.isEmpty, "Client identity required")

        let descriptor = FetchDescriptor<ClientProfile>()

        if let existing = try? modelContext.fetch(descriptor)
            .first(where: { $0.email == email }) {
            return existing
        }

        let client = ClientProfile(name: name, email: email)
        modelContext.insert(client)
        return client
    }
}
