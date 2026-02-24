//
//  ActiveClientBanner.swift
//  Better Fit
//
//  Created by Derek Preston on 2/23/26.
//

import SwiftUI

struct ActiveClientBanner: View {
    let client: ClientProfile
    let onSwitch: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Active Client")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(client.name)
                    .font(.headline)
            }

            Spacer()

            Button("Switch") {
                onSwitch()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
