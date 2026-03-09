//
//  AuthService.swift
//  Better Fit
//
//  Created by Derek Preston on 3/8/26.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import Combine

@MainActor
class AuthService: ObservableObject {

    @Published var user: User?
    @Published var userRole: String?

    init() {
        user = Auth.auth().currentUser
    }

    func signUp(email: String, password: String, role: String) async throws {

        let result = try await Auth.auth()
            .createUser(withEmail: email, password: password)

        user = result.user

        try await FirestoreService.shared.createUserProfile(
            email: email,
            role: role
        )

        userRole = role
    }

    func signIn(email: String, password: String) async throws {
        let result = try await Auth.auth()
            .signIn(withEmail: email, password: password)

        user = result.user
    }

    func signOut() throws {
        try Auth.auth().signOut()
        user = nil
    }
    
    func loadUserRole() async {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()

        do {

            let document = try await db
                .collection("users")
                .document(uid)
                .getDocument()

            if let role = document.data()?["role"] as? String {
                userRole = role
            }

        } catch {
            print("Failed to load role:", error)
        }

    }
}
