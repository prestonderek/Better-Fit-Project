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
    @EnvironmentObject var clientSession: ClientSession
    
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
                    ForEach(clients.filter {
                        !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                        !$0.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    }, id: \.id) { client in
                        NavigationLink {
                            ClientDetailView(client: client)
                        } label: {
                            CardView {
                                Text(client.name)
                                    .font(Theme.Fonts.title)

                                Text(client.email)
                                    .font(Theme.Fonts.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .simultaneousGesture(
                            TapGesture().onEnded {
                                clientSession.activeClient = client
                            }
                        )
                    }
                    .listRowBackground(Color.clear)
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

