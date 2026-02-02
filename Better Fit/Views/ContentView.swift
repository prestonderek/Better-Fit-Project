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
            }

            ProfileView(store: store)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
        .onAppear {
            store.loadOrCreateProfile(modelContext: modelContext)
        }
    }
}
