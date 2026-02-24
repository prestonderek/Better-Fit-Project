//
//  AddClientView.swift
//  Better Fit
//
//  Created by Derek Preston on 2/20/26.
//

import SwiftUI
import SwiftData

struct AddClientView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var clientSession: ClientSession

    @State private var name = ""
    @State private var email = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Client Info") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Section {
                    Button("Add Client") { addClient() }
                        .buttonStyle(.borderedProminent)
                        .tint(Brand.Accent.primary)
                }
            }
            .navigationTitle("Add Client")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .alert("Oops", isPresented: .constant(errorMessage != nil)) {
                Button("OK") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    private func addClient() {
        do {
            let validName = try Validators.nonEmpty(name, fieldName: "Name", minChars: 2)
            let validEmail = try Validators.nonEmpty(email, fieldName: "Email", minChars: 5)

            let newClient = ClientProfile(name: validName, email: validEmail)
            modelContext.insert(newClient)

            //immediately select the new client
            clientSession.activeClient = newClient
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
