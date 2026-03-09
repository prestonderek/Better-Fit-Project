//
//  AuthGateView.swift
//  Better Fit
//
//  Created by Derek Preston on 3/8/26.
//

import SwiftUI
import FirebaseAuth

struct AuthGateView: View {

    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var clientSession: ClientSession

    var body: some View {

        if authService.user == nil {

            LoginView()

        } else if authService.userRole == "trainer" {

            TrainerDashboardView()

        } else if authService.userRole == "client" {

            ClientDashboardView()
                .task {
                    initializeClient()
                }

        } else {

            ProgressView("Loading profile...")
                .task {
                    await authService.loadUserRole()
                }

        }
    }

    func initializeClient() {

        guard let user = authService.user else { return }

        if clientSession.activeClient == nil {

            clientSession.activeClient = ClientProfile(
                name: user.email ?? "Client",
                email: user.email ?? ""
            )

        }
    }
}
