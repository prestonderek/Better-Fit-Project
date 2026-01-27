//
//  ContentView.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI

enum AppRole: String, CaseIterable, Codable {
    case client
    case trainer
}

struct ContentView: View {
    @State private var role: AppRole = .client  // Sprint 1: simple toggle

    var body: some View {
        TabView {
            Group {
                if role == .client {
                    ClientDashboardView()
                } else {
                    TrainerDashboardView()
                }
            }
            .tabItem {
                Label("Dashboard", systemImage: "rectangle.grid.2x2")
            }

            ProfileView(role: $role)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}
