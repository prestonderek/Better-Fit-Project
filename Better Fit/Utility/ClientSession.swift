//
//  ClientSession.swift
//  Better Fit
//
//  Created by Derek Preston on 2/22/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class ClientSession: ObservableObject {
    @Published var activeClient: ClientProfile?
}
