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

    @State private var name: String = ""
    @State private var email: String = ""
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
                }
            }
            .navigationTitle("Add Client")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .alert("Oops", isPresented: .constant(errorMessage != nil), actions: {
                Button("OK") { errorMessage = nil }
            }, message: {
                Text(errorMessage ?? "")
            })
        }
    }

    private func addClient() {
        do {
            let validName = try Validators.nonEmpty(name, fieldName: "Name", minChars: 2)
            let validEmail = try Validators.nonEmpty(email, fieldName: "Email", minChars: 5)

            modelContext.insert(
                ClientProfile(name: validName, email: validEmail)
            )
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
