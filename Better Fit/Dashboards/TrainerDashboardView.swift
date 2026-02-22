//
//  TrainerDashboardView.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import SwiftUI
import SwiftData

struct TrainerDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\ClientProfile.createdAt)])
    private var clients: [ClientProfile]

    @State private var showingAddClient = false

    var body: some View {
        NavigationStack {
            List {
                if clients.isEmpty {
                    ContentUnavailableView(
                        "No clients yet",
                        systemImage: "person.3",
                        description: Text("Add your first client to get started.")
                    )
                } else {
                    ForEach(clients, id: \.id) { client in
                        NavigationLink {
                            ClientDetailView(client: client)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(client.name)
                                    .font(.headline)
                                Text(client.email)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Trainer Dashboard")
            .toolbar {
                Button {
                    showingAddClient = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddClient) {
                AddClientView()
            }
        }
    }
}

