//
//  TrainerClientPickerView.swift
//  Better Fit
//
//  Created by Derek Preston on 2/23/26.
//

import SwiftUI
import SwiftData

struct TrainerClientPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var clientSession: ClientSession

    @Query(sort: \ClientProfile.name)
    private var clients: [ClientProfile]

    var body: some View {
        NavigationStack {
            List {
                ForEach(validClients) { client in
                    Button {
                        clientSession.activeClient = client
                        dismiss()
                    } label: {
                        VStack(alignment: .leading) {
                            Text(client.name)
                            Text(client.email)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Select Client")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private var validClients: [ClientProfile] {
        clients.filter {
            !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !$0.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
}
