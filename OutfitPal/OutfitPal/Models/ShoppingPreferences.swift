//
//  ShoppingPreferences.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/1/25.
//

import Foundation

struct ShoppingPreferences: Codable {
    var preferredBrands: [String] // List of preferred clothing brands
    var preferredColors: [String]
    var budgetRange: String // e.g., "$50-$100"
    var size: String // User's preferred size (e.g., "M", "L", "32W")
}
