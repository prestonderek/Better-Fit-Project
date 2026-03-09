//
//  FirestoreService.swift
//  Better Fit
//
//  Created by Derek Preston on 3/9/26.
//

import FirebaseFirestore
import FirebaseAuth

class FirestoreService {

    static let shared = FirestoreService()

    private let db = Firestore.firestore()

    func createUserProfile(email: String, role: String) async throws {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        try await db.collection("users")
            .document(uid)
            .setData([
                "uid": uid,
                "email": email,
                "role": role,
                "createdAt": Timestamp()
            ])
    }

    func createClient(name: String, email: String) async throws {

        guard let trainerId = Auth.auth().currentUser?.uid else { return }

        let clientId = UUID().uuidString

        try await db.collection("clients")
            .document(clientId)
            .setData([
                "trainerId": trainerId,
                "name": name,
                "email": email,
                "createdAt": Timestamp()
            ])
    }

}
