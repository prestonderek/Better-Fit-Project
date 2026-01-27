//
//  ProfileView.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI

struct ProfileView: View {
    @Binding var role: AppRole

    var body: some View {
        NavigationStack {
            Form {
                Section("Mode (Sprint 1)") {
                    Picker("Role", selection: $role) {
                        Text("Client").tag(AppRole.client)
                        Text("Trainer").tag(AppRole.trainer)
                    }
                    .pickerStyle(.segmented)
                }

                Section("Profile") {
                    Text("Profile editing comes next.")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

