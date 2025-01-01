//
//  Outfit.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/1/25.
//

import Foundation

struct Outfit: Identifiable, Codable {
    let id: String
    let name: String
    let clothingItems: [ClothingItem] 
    let occasion: String // e.g., "Party", "Work"
    let dateCreated: Date
}
