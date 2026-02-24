//
//  ProfileView.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var store: UserProfileStore

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var role: AppRole = .client

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Role", selection: $role) {
                        Text("Client").tag(AppRole.client)
                        Text("Trainer").tag(AppRole.trainer)
                    }
                    .pickerStyle(.segmented)
                }
                header: {
                    SectionHeaderView("Mode", systemImage: "rectangle.on.rectangle")
                }

                Section {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                } header: {
                    SectionHeaderView("Profile", systemImage: "person.circle")
                }

                Section {
                    Button("Save") { save() }
                        .buttonStyle(.borderedProminent)
                } 
            }
            .navigationTitle("Profile")
            .onAppear { loadToUI() }
        }
    }

    private func loadToUI() {
        // Ensure we have a profile loaded
        store.loadOrCreateProfile(modelContext: modelContext)

        guard let p = store.profile else { return }
        name = p.name
        email = p.email
        role = p.role
    }

    private func save() {
        store.loadOrCreateProfile(modelContext: modelContext)
        guard let p = store.profile else { return }

        p.name = name
        p.email = email
        p.role = role
        // SwiftData autosaves changes; no explicit save needed.
    }
}

