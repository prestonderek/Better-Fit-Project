//
//  SectionHeaderView.swift
//  Better Fit
//
//  Created by Derek Preston on 2/22/26.
//

import SwiftUI

struct SectionHeaderView: View {
    let title: String
    let systemImage: String?

    init(_ title: String, systemImage: String? = nil) {
        self.title = title
        self.systemImage = systemImage
    }

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundStyle(Brand.Accent.primary)
            }

            Text(title.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(.top, Theme.Spacing.sm)
    }
}

