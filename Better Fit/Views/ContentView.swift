//
//  ContentView.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var store = UserProfileStore()
    @StateObject private var clientSession = ClientSession()

    var body: some View {
        TabView {
            Group {
                if (store.profile?.role ?? .client) == .client {
                    ClientDashboardView()
                } else {
                    TrainerDashboardView()
                }
            }
            .tabItem {
                Label("Dashboard", systemImage: "rectangle.grid.2x2")
                    .tint(Brand.Accent.primary)
            }

            ProfileView(store: store)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                        .tint(Brand.Accent.primary)
                }
        }
        .environmentObject(clientSession)
        .onAppear {
            store.loadOrCreateProfile(modelContext: modelContext)

            guard
                let profile = store.profile,
                profile.role == .client
            else {
                return
            }

            let name = profile.name.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = profile.email.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !name.isEmpty, !email.isEmpty else {
                clientSession.activeClient = nil
                return
            }

            clientSession.activeClient =
                ClientBootstrapper.ensureClientProfile(
                    userProfile: profile,
                    modelContext: modelContext
                )
        }
    }
}
