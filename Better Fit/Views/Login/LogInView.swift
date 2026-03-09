//
//  LogInView.swift
//  Better Fit
//
//  Created by Derek Preston on 3/8/26.
//

import SwiftUI

struct LoginView: View {

    @EnvironmentObject var authService: AuthService

    @State private var role: String = "trainer"
    @State private var email = ""
    @State private var password = ""

    @State private var errorMessage: String?

    var body: some View {

        NavigationStack {

            VStack(spacing: 24) {

                Text("BetterFit")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                Picker("Account Type", selection: $role) {
                    Text("Trainer").tag("trainer")
                    Text("Client").tag("client")
                }
                .pickerStyle(.segmented)

                Button("Sign In") {
                    signIn()
                }
                .buttonStyle(.borderedProminent)

                Button("Create Account") {
                    signUp()
                }

            }
            .padding()
            .alert("Authentication Error",
                   isPresented: .constant(errorMessage != nil)) {

                Button("OK") { errorMessage = nil }

            } message: {

                Text(errorMessage ?? "")

            }

        }

    }

    func signIn() {

        Task {
            do {
                try await authService.signIn(email: email, password: password)
            } catch {
                errorMessage = error.localizedDescription
            }
        }

    }

    func signUp() {

        Task {
            do {
                try await authService.signUp(email: email, password: password, role: role)
            } catch {
                errorMessage = error.localizedDescription
            }
        }

    }

}
