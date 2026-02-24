//
//  Theme.swift
//  Better Fit
//
//  Created by Derek Preston on 2/22/26.
//

import SwiftUI

enum Theme {
    enum Colors {
        static let primary = Color.blue
        static let secondary = Color.indigo
        static let background = Color(.systemGroupedBackground)
        static let cardBackground = Color(.secondarySystemBackground)
        static let accent = Color.green
        static let destructive = Color.red
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
    }

    enum Fonts {
        static let title = Font.title2.weight(.semibold)
        static let sectionHeader = Font.subheadline.weight(.medium)
        static let body = Font.body
        static let caption = Font.caption
    }

    enum CornerRadius {
        static let card: CGFloat = 12
        static let button: CGFloat = 10
    }
}

enum Brand {
    static let name = "Better Fit"
    
    enum Accent {
        static let primary = Color.teal
        static let secondary = Color.indigo
        static let highlight = Color.orange
    }
}
