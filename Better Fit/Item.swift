//
//  Item.swift
//  Better Fit
//
//  Created by Derek Preston on 1/26/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
